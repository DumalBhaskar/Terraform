## Use a data source to retrieve the details of an existing security group and apply it to a new EC2 instance.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "mymagicbucket143"
    key    = "tftask07.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}

variable "security_group_id" {
    default = "sg-00dbd664ecc12ce82"
}

data "aws_security_group" "selected" {
  id = var.security_group_id
}

resource "aws_instance" "app_server" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_security_group.selected.id]

 tags = {
    Name = "test1"
  }
}
