
# route table for public subnets
resource "aws_route_table" "public" {
 vpc_id = aws_vpc.main.id
 
# Routes all traffic through the internet gateway
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.main.id # Route through IG
 }
 
 tags = {
   Name = "Public route table"
 }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# route table for private subnets
resource "aws_route_table" "private" {
  count  = length(aws_nat_gateway.nat)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat[*].id, count.index)  # Route through NAT
  }

  tags = {
    Name = "Private route table"
  }
}


# Associate private route table with private subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}