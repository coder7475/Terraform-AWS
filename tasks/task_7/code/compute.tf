
resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  # count = var.instance_count
  availability_zone           = var.availability_zone
  monitoring                  = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name = "my_instance",
  }
}