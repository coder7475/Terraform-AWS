terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create a S3 bucket
resource "aws_s3_bucket" "my-bucket" {
  bucket = "terraform-aws-coder7475-bucket-101"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

