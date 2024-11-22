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
    Name = "security-group-Kibana"
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
    Name = "security-group-application"
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
    Name = "security-group-Logstash"
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
    Name = "security-group-elasticsearch"
  }
}