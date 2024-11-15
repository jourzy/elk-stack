resource "aws_subnet" "public" {
  count             = length(var.cidr_blocks_subnet_public)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks_subnet_public, count.index)
  availability_zone = element(var.availability_zones, count.index)

    tags = {
    Name = "Public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "application" {
  count             = length(var.cidr_blocks_subnet_application)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks_subnet_application, count.index)
  availability_zone = element(var.availability_zones, count.index)

    tags = {
    Name = "Application subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "backend" {
  count             = length(var.cidr_blocks_subnet_backend)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks_subnet_backend, count.index)
  availability_zone = element(var.availability_zones, count.index)

    tags = {
    Name = "Backend subnet ${count.index + 1}"
  }
}