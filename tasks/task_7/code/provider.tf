
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
}



# backend configuration
terraform {
  backend "s3" {
    bucket       = "terraform-state-1767446337"
    key          = "dev/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
    encrypt      = true
  }
}
