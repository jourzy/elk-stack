resource "aws_internet_gateway" "main" {
vpc_id = aws_vpc.main.id

 tags = {
   Name = "elk-internet-gateway"
 }
}

# Allocate an Elastic IP (EIP) for NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "elk-nat-eip"
  }
}


# NAT Gateway to go in public subnet 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id  
  subnet_id     = aws_subnet.public.id  # Place the NAT gateway in the public subnet
  tags = {
    Name = "elk-nat-gateway"
  }

  # Good practice to depend on the Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

