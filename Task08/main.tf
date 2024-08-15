## Utilize the terraform-aws-modules/s3-bucket/aws module from the Terraform Registry to create an S3 bucket with versioning enabled. Ensure you configure the bucket's name and enable versioning.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.27"
    }
  }

  backend "s3" {
    bucket = "mymagicbucket143"
    key    = "tftask08.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-south-1"
}


module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "myblackbigbucket"

  versioning = {
    enabled = true
  }
}