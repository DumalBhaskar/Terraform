## Create a custom module that launches an EC2 instance and creates a security group that allows SSH access. Use this module in a root module to launch the instance with the security group.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "mymagicbucket143"
    key    = "tftask09.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
      source = "./modules/ec2"
      instance_name = "my-ec2-instance"
      instance_ami  = "ami-0ad21ae1d0696ad58"
      instance_type = "t2.micro"
      security_group_name = "mytestsg"
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = module.ec2.instance_id
}

output "security_group_id" {
  
  value       = module.ec2.security_group_name
}