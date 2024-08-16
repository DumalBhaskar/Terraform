provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "clops-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
 
  tags = {
    name = "clops-vpc"
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "bation-server-sg"
  
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    name = "bation-server-sg"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion-instance"
  ami = "ami-0ae8f15ae66fe8cda"
  instance_type          = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.web_server_sg.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
     name = "bastion-instance"
  }
}

