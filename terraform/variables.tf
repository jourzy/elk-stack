
variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
  default     = "public"
}


variable "instance_tag" {
  description = "Tag given to each deployed Instance"
  type        = string 
  default     = "instance"
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


variable "cidr_block_ingress" {
    description = "CIDR Block ingress"
    type        = list(string)
}

