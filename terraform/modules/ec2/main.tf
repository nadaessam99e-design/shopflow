resource "aws_security_group" "bastion_sg" {
  name        = "shopflow-bastion-sg"
  description = "Security Group for Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # بعدين ممكن نخليها IP بتاعك فقط
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopflow-bastion-sg"
  }
}
resource "aws_security_group" "app_sg" {
  name        = "shopflow-app-sg"
  description = "Security Group for App EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # هنعدلها بعدين لما نضيف الـ ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopflow-app-sg"
  }
}
resource "aws_instance" "bastion" {
  ami                    = "ami-08f44e8eca9095668"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  key_name = "shopflow-key"

  associate_public_ip_address = true

  tags = {
    Name = "shopflow-bastion"
  }
}
resource "aws_iam_role" "ec2_role" {
  name = "shopflow-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "shopflow-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
resource "aws_launch_template" "app" {
  name_prefix   = "shopflow-"
  image_id      = "ami-08f44e8eca9095668"
  instance_type = "t2.micro"

  key_name = "shopflow-key"

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install docker -y
systemctl enable docker
systemctl start docker
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "shopflow-app"
    }
  }
}
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = 2
  min_size         = 1
  max_size         = 3

  vpc_zone_identifier = [
    var.private_subnet_id,
    var.private_subnet2_id
  ]

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "shopflow-app"
    propagate_at_launch = true
  }
}
resource "aws_lb_target_group" "app" {
  name     = "shopflow-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}
resource "aws_lb" "app" {
  name               = "shopflow-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.app_sg.id
  ]

  subnets = [
    var.public_subnet_id,
    var.public_subnet2_id
  ]
}
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

