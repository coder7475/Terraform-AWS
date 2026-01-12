resource "aws_vpc" "main" {
  cidr_block = var.cidr_block[0]
  tags = {
    Name = "my_vpc",
    learning = "list variable"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.cidr_block[1]

  tags = {
    Name = "my_vpc_subnet_1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.cidr_block[2]

  tags = {
    Name = "my_vpc_subnet_2"
  }
}