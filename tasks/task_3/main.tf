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

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main-vpc"
  }
}

# Create a S3 bucket
resource "aws_s3_bucket" "data-bucket" {
  bucket = "my-data-bucket-${aws_vpc.main.id}"

  tags = {
    Name        = "My Data bucket"
    VPC = aws_vpc.main.id
    Environment = "Dev"
  }
}

