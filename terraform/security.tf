resource "aws_security_group" "private" {
  name        = "Security group for instances in private subnet"
  description = "Allows ssh into private instances from bastion and all egress traffic"
  vpc_id      = aws_vpc.main.id


  # Allow ssh from bastion host's private ip
  ingress {
    description = "Allow SSH from bastion host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["${aws_instance.bastion.private_ip}/32"]  # Bastion's private IP with /32
  }

  

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # semantically equivalent to all ports and procotols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security group for instances in private subnet"
  }
}


resource "aws_security_group" "public" {
  name        = "Security group for bastion in public subnet"
  description = "Security group for bastion host allowing ssh access from my public ip adress and all egress traffic"
  vpc_id      = aws_vpc.main.id


  /* Ensure that the bastion host allows SSH access from your IP address 
  or network by keeping the original ingress rule 
  (which allows SSH from a specific CIDR block) 
  in the bastion host's security group.*/
  ingress {
    description = "Allow SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # replace variable with your own public ip address
    cidr_blocks = var.cidr_block_ingress

  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




# Alternative to using ingress and egress arguments of the aws_security_group resource
# As reccommended here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

# resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = aws_vpc.main.cidr_block
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

