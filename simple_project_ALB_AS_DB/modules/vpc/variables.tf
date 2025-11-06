variable "vpc_cidr" {
    description = "CIDR for VPC"
    type = string
  
}

variable "public_subnet_cidrs" {
    description = "List of CIDR for public subnet"
    type = list(string)
  
}

variable "env_tag" {
    description = "Environment tag for resource labeling"
    type = string
  
}

variable "private_subnet_cidrs" {
    description = "List od CIDRs private subnets"
    type = list(string)
  
}

