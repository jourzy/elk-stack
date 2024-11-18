resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

    tags = {
    Name = "Public subnet elk-stack"
  }
}

resource "aws_subnet" "application" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"

    tags = {
    Name = "Application subnet elk-stack"
  }
}

resource "aws_subnet" "backend" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2a"

    tags = {
    Name = "Backend subnet elk-stack"
  }
}