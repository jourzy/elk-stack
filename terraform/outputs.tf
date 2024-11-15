output "private_instance_public_ips" {
  description = "The private ip addresses of the private EC2 instances for ssh access"
  # Maps the instance ids to their private ips
  value       = {for instance in aws_instance.private : instance.id => instance.private_ip}
}


output "public_subnet_ids" {
  description = "The ids of the public subnets to assign to EC2s"
  # Gets the ids of all the aws_subnet resources that have the name public
  value       = aws_subnet.public[*].id
}


output "bastion_public_ip" {
  description = "The public ip address of the bastion host"
  value       = aws_instance.bastion.public_ip
}
