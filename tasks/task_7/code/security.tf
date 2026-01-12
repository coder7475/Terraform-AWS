resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Web SG with a single ingress rule from tuple."

  ingress {
    from_port   = var.ingress_values[0]
    protocol    = var.ingress_values[1]
    to_port     = var.ingress_values[2]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
