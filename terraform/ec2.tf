data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter{
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  
}


resource "aws_instance" "application" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = ["${aws_security_group.application.id}"]
  associate_public_ip_address = false

  subnet_id                   = aws_subnet.application.id
  
  tags                        = { Name = "application-server" }
}

resource "aws_instance" "kibana" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = t2.micro
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = ["${aws_security_group.kibana.id}"]
  associate_public_ip_address = true

  subnet_id                   = aws_subnet.public.id

  tags                        = { Name = "kibana-server" }
}

resource "aws_instance" "logstash" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = t2.micro
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = ["${aws_security_group.logstash.id}"]
  associate_public_ip_address = true

  subnet_id                   = aws_subnet.private.id

  tags                        = { Name = "logstash-server" }
}

resource "aws_instance" "elasticsearch" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = t3.small
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = ["${aws_security_group.elasticsearch.id}"]
  associate_public_ip_address = true

  subnet_id                   = aws_subnet.private.id

  tags                        = { Name = "elasticsearch-server" }
}
