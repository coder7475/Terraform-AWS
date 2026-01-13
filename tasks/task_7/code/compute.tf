
resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  count = var.config.instance_count
  availability_zone           = var.availability_zone
  monitoring                  = var.config.monitoring
  associate_public_ip_address = var.associate_public_ip


  # precondition
  lifecycle {
    precondition {
      condition = contains(var.allowed_vm_types, var.instance_type)
      error_message = "Unauthorized instance type '${var.instance_type}'. Allowed types: ${join(",", var.allowed_vm_types)}"
    }
  }

  tags = {
    Name = "my_instance",
  }
}