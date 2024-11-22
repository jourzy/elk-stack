# Security group for Kibanan instance
# Allows inbound traffic from my ip
# Allows ssh from my ip
# Allows all outbound traffic
resource "aws_security_group" "kibana" {
  name        = "kibana-security-group"
  description = "Security group for Kibana instance"
  vpc_id      = aws_vpc.main.id

  # Kibana runs on port 5601
  ingress {
    description = "Access Kibana from my ip address"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = var.cidr_block_ingress
  }

  # Port 22 is the default ssh port
  ingress {
    description = "Allow ssh into Kibana from my ip address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.cidr_block_ingress
  }

  egress {
    description = "Allow all outbound traffic from Kibana instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

      tags = {
    Name = "Security group for Kibana instance"
  }
}

# Security group for application instance
# No inbound traffic - currently commented out
# All outbound traffic allowed
resource "aws_security_group" "application" {
  name        = "application-security-group"
  description = "Security group for application instance"
  vpc_id      = aws_vpc.main.id

  # ingress {
  #   description = "Allow ssh into application from my ip"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = var.cidr_block_ingress
  # }

  egress {
    description = "Allow all outbound traffic from application"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

      tags = {
    Name = "Security group for Application instance"
  }
}

# Security group for Logstash instance
# Allows traffic from application SG to Logstash
# Allow ssh from Kibana
# Allow all outbound traffic
resource "aws_security_group" "logstash" {
  name        = "logstash-security-group"
  description = "Security group for Logstash instance"
  vpc_id      = aws_vpc.main.id


  # Allow application to send data to Logstash
  # 5044 is port used by Logstash
  ingress {
    description     = "Allow access to Logstash from application"
    from_port       = 5044
    to_port         = 5044
    protocol        = "tcp"
    security_groups = [aws_security_group.application.id]
  }


  # Allow ssh into Logstash from Kibana
  ingress {
    description     = "Allow ssh into Logstash from Kibana"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.kibana.id]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic from backend"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

      tags = {
    Name = "Security group for Logstash instance"
  }
}


# Security group for Elasticsearch instance
# Allows traffic from Kibana to Elasticsearch
# Allow ssh from Kibana
# Allow all outbound traffic
resource "aws_security_group" "elasticsearch" {
  name        = "elasticsearch-security-group"
  description = "Security group for Elasticsearch instance"
  vpc_id      = aws_vpc.main.id

  # Allow access to Elasticsearch from Kibana
  # Port 9200 is the default HTTP port for Elasticsearch, used for client communication and sending REST requests.
  ingress {
    description     = "Allow access to Elasticsearch from Kibana"
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.kibana.id]
  }


  # Allow ssh from Kibana to elasticsearch
  ingress {
    description = "Allow ssh from Kibana to elasticsearch instance"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.kibana.id]
    # cidr_blocks = ["${aws_instance.kibana.private_ip}"]  # Bastion's private IP with /32 
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic from backend"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "Security group for Elasticsearch instance"
  }
}




###########################################################




  

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

