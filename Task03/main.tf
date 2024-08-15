##Create a Terraform script to provision an EC2 instance called test2  along with a security group that allows inbound SSH (port 22) and HTTP (port 80) traffic.


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket = "mymagicbucket143"
    key    = "tftask03.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "app_server" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.test.id]

  tags = {
    Name = "test2"
  }
}


resource "aws_security_group" "test" {
  name        = "mytestsg"

  tags = {
    Name = "mytestsg"
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}

