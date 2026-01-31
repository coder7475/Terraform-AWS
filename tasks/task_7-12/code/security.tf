resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Web SG with a single ingress rule from tuple."

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      protocol    = ingress.value.protocol
      to_port     = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
