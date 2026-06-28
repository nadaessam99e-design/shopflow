module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"

  public_subnet2_cidr  = "10.0.3.0/24"
  private_subnet2_cidr = "10.0.4.0/24"

  availability_zone    = "us-east-1a"
  availability_zone2   = "us-east-1b"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnet_id
  public_subnet2_id  = module.vpc.public_subnet2_id

  private_subnet_id  = module.vpc.private_subnet_id
  private_subnet2_id = module.vpc.private_subnet2_id
}
module "rds" {

  source = "./modules/rds"

  vpc_id = module.vpc.vpc_id

  private_subnet_id = module.vpc.private_subnet_id

  private_subnet2_id = module.vpc.private_subnet2_id

  app_security_group_id = module.ec2.app_sg_id

}
module "iam" {
  source = "./modules/iam"
}
module "ecr" {
  source = "./modules/ecr"
}
