resource "aws_security_group" "rds_sg" {
  name   = "shopflow-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "db" {
  name = "shopflow-db-subnet"

  subnet_ids = [
    var.private_subnet_id,
    var.private_subnet2_id
  ]
}
resource "aws_db_instance" "mysql" {

  identifier = "shopflow-db"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  username = "admin"

  password = "Shopflow123!"

  db_subnet_group_name = aws_db_subnet_group.db.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true
}

