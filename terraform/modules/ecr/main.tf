resource "aws_ecr_repository" "shopflow" {
  name = "shopflow"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "shopflow-ecr"
  }
}
