variable "aws_region" {
    description = "Region AWS"
    type = string
  
}

variable "vpc_cidr" {
    description = "CIDR for VPC"
    type = string
  
}

variable "public_subnet_cidrs" {
    description = "Value of CIDR for public subnet"
    type = list(string)
  
}

variable "private_subnet_cidrs" {
    description = "List od Cidrs private subnets"
    type = list(string)
  
}

variable "key_name" {
    description = "Name of existing SSH key in AWS for EC2"
    type = string
}

variable "instance_type" {
    description = "Type of instance EC2"
    type = string
  
}

variable "db_instance_class" {
    description = "Type of instance class"
    type = string
  
}

variable "db_username" {
    description = "User master database"
    type = string
  
}

variable "db_password" {
    description = "Password for DB"
    type = string
    sensitive = true
  
}

variable "db_name" {
    description = "Name of DB"
    type = string
    default = "appDB"
  
}
