provider "aws" {
  region = var.region
}

resource "aws_instance" "app_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  security_groups = [aws_security_group.test.name]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "test" {

  name        = var.security_group_name

  tags = {
    Name = var.security_group_name
  }

 
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
