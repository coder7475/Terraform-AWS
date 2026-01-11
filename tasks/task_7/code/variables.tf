# Input Variables - Values provided to Terraform configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region"
  type = string
  default = "ap-southeast-1"
}

variable "availability_zone" {
  type = string
  default = "ap-southeast-1a"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "my-terraform-bucket"
}

variable "instance_count" {
  description = "The number of ec2 instances"
  type = number
  default = 2
}

variable "monitoring_enabled" {
  description = "whether detailed monitoring is enabled"
  type = bool
  default = false
}

variable "associate_public_ip" {
    type = bool
    description = "associate public ip to ec2 instance"
    default = true
}

