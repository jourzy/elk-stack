resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "elk-stack vpc"
  }
}