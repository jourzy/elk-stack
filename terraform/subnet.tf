resource "aws_subnet" "public" {
  count             = length(var.cidr_blocks_subnet_public)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks_subnet_public, count.index)
  availability_zone = element(var.availability_zones, count.index)

    tags = {
    Name = "Public subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.cidr_blocks_subnet_private)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.cidr_blocks_subnet_private, count.index)
  availability_zone = element(var.availability_zones, count.index)

    tags = {
    Name = "Private subnet ${count.index + 1}"
  }
}