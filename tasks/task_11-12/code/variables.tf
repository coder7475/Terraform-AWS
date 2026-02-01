variable "project_name" {
  default = "Project ALPHA Resources"
}

variable "default_tags" {
  default = {
    company = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environmental_tags" {
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

variable "bucket_name" {
  default = "ProjectAlphaStorageBucket with CAPS and spaces!!!"
}

variable "allowed_ports" {
  default = "80,443,8080,3306"
}

variable "instance_sizes" {
  type = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }
}

variable "environment" {
  default = "dev"
}