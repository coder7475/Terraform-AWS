# Simple S3 Bucket using all three types of variables
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.full_bucket_name # Local variable (computed)

  tags = local.common_tags # Local variable (tags)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  count = var.instance_count
  availability_zone = var.availability_zone

  tags = {
    Name = "my_instance",
    Count = count.index
  }
}