
variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
  default     = "public"
}


variable "instance_type" {
  description = "Type of EC2 instance to provision"
  type        = string
  default     = "t2.micro"
}

variable "instance_tag" {
  description = "Tag given to each deployed Instance"
  type        = string 
  default     = "instance"
}


variable "counter" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}


variable "file_name" {
  description = "Name of the key pair"
  type        = string
  default     = "public.pem"
}


variable "cidr_block_vpc" {
  description = "CIDR Block range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_blocks_subnet_public" {
  description = "CIDR Blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cidr_blocks_subnet_backend" {
  description = "CIDR Blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cidr_blocks_subnet_application" {
  description = "CIDR Blocks for private subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}



variable "cidr_block_ingress" {
    description = "CIDR Block ingress"
    type        = list(string)
}


variable "availability_zones"{
  description = "Availability Zones for the Subnet"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}