# Input Variables - Values provided to Terraform configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "ap-southeast-1"
  validation {
    condition = contains(var.allowed_region, var.region)
    error_message = "Region '${var.region}' is not allowed. Allowed regions: ${join(", ", tolist(var.allowed_region))}."
  }
}

variable "allowed_region" {
  description = "set of allowed region"
  type = set(string)
  default = [ "ap-southeast-1", "ap-northeast-1" ]
}

variable "availability_zone" {
  type    = string
  default = "ap-southeast-1a"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "my-terraform-bucket"
}

variable "instance_count" {
  description = "The number of ec2 instances"
  type        = number
  default     = 2
}

variable "monitoring_enabled" {
  description = "whether detailed monitoring is enabled"
  type        = bool
  default     = false
}

variable "associate_public_ip" {
  type        = bool
  description = "associate public ip to ec2 instance"
  default     = true
}

variable "cidr_block" {
  type = list(string)
  description = "cidr blocks for vpc"
  default = [ "10.0.0.0/16", "10.0.0.0/8" ]
}

variable "allowed_vm_types" {
  description = "Approved EC2 instance types per org policy."
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "instance_type" {
  description = "EC2 instance type to deploy."
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "tags for VPC"
  type = map(string)
  default = {
    Environment = "dev", 
    Name = "dev-Instance", 
    created_by = "terraform"
  }
}

variable "ingress_values" {
  description = "Tuple: [from_port, protocol, to_port]."
  type        = tuple([number, string, number])
  default     = [443, "tcp", 443]
}

variable "config" {
  description = "Configuration Object for AWS deployment Setting"
  type = object({
    region = string
    monitoring = bool
    instance_count = number
  })
  default = {
    region = "ap-southeast-1"
    monitoring = true
    instance_count = 1
  }
}