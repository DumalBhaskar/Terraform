provider "aws" {
   region = "ap-south-1"

}



resource "aws_iam_user" "user" {
  name = "Clops_user"
  path = "/"
 
}

resource "aws_iam_user_login_profile" "example" {
  user    = aws_iam_user.user.name
  password_reset_required = true
  
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = false
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_group" "group" {
  name = "CLOpsAdmins"
  path = "/"
}

resource "aws_iam_user_group_membership" "example1" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name
  ]
}

resource "aws_iam_policy" "policy" {
  name  = "my_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.name

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "CLOpsAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


################################################################################



resource "aws_vpc" "mystic-falls" {
  cidr_block       = "10.0.0.0/24"
  
  tags = {
    Name = "mystic-falls"
  }
}

resource "aws_subnet" "public_subnet" {
  count      = length(var.cidr_public_subnet)
  vpc_id     = aws_vpc.mystic-falls.id
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subet  ${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count      = length(var.cidr_private_subnet)
  vpc_id     = aws_vpc.mystic-falls.id
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)
  
  tags = {
    Name = "private_subet  ${count.index}"
  }
}

resource "aws_subnet" "private_subnetdb" {
  count      = length(var.cidr_private_subnetdb)
  vpc_id     = aws_vpc.mystic-falls.id
  cidr_block = element(var.cidr_private_subnetdb, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)
  
  tags = {
    Name = "private_subetdb  ${count.index}"
  }
}

resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.example.id
  vpc_id              = aws_vpc.mystic-falls.id
}


resource "aws_internet_gateway" "example" {

  tags = {
    Name = "public_IGW"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.mystic-falls.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }


  tags = {
    Name = "Public_RT"
  }
}


resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.cidr_public_subnet)
  depends_on = [aws_subnet.public_subnet, aws_route_table.example]
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.example.id
}


data "aws_subnet" "public_subnet" {
  filter {
    name = "tag:Name"
    values = ["public_subet  0"]
  }

  
}


resource "aws_instance" "ec2_example2" {
  ami = "ami-0e53db6fd757e38c7"
  instance_type = "t2.micro"
  tags = {
    Name = "Bastion Host2"
  }
  key_name= "ec2"
  subnet_id = data.aws_subnet.public_subnet.id
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  vpc_security_group_ids = [aws_security_group.public_SG.id]
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}

resource "aws_security_group" "public_SG" {
  name        = "public_SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.mystic-falls.id

  tags = {
    Name = "public_SG"
  }

 egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress                = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}



#####################################################################################


resource "aws_vpc" "clock-tower" {
  cidr_block       = "192.168.0.0/24"

  tags = {
    Name = "clock-tower"
  }
}


resource "aws_subnet" "new_public_subnet" {
  
  vpc_id     = aws_vpc.clock-tower.id
  cidr_block = "192.168.0.0/25"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "new_public_subet_01"
  }
}

resource "aws_subnet" "new_private_subnet" {
  
  vpc_id     = aws_vpc.clock-tower.id
  cidr_block = "192.168.0.128/25"
  availability_zone = "ap-south-1b"
  
  tags = {
    Name = "new_private_subet_02"
  }
}























variable "cidr_private_subnetdb" {
  type        = list(string)
  description = "Private Subnet db CIDR values"
  default     = ["10.0.0.128/27", "10.0.0.160/27"]
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/27", "10.0.0.32/27"]
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.64/27", "10.0.0.96/27"]
}

variable "eu_availability_zone" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["ap-south-1a", "ap-south-1b"]
}

output "password" {
  value = aws_iam_user_login_profile.example.password
  sensitive = true
}
