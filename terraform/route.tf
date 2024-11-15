
# route table for public subnets
resource "aws_route_table" "public" {
 vpc_id = aws_vpc.main.id
 
# Routes all traffic through the internet gateway
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.main.id # Route through IG
 }
 
 tags = {
   Name = "Public subnet route table"
 }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}


# route table for application subnets
resource "aws_route_table" "application" {
 vpc_id = aws_vpc.main.id
 
# Routes all traffic through the internet gateway
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.main.id # Route through IG
 }
 
 tags = {
   Name = "Application subnet route table"
 }
}

# Associate application route table with application subnets
resource "aws_route_table_association" "application" {
  count          = length(aws_subnet.application)
  subnet_id      = element(aws_subnet.application[*].id, count.index)
  route_table_id = aws_route_table.application.id
}


# route table for backend subnets
# Routes all traffic through the nat gateway
resource "aws_route_table" "backend" {
  count  = length(aws_nat_gateway.nat)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat[*].id, count.index)  # Route through NAT
  }

  tags = {
    Name = "Backend route table"
  }
}


# Associate backend route table with backend subnets
resource "aws_route_table_association" "backend" {
  count          = length(aws_subnet.backend)
  subnet_id      = element(aws_subnet.backend[*].id, count.index)
  route_table_id = element(aws_route_table.backend[*].id, count.index)
}