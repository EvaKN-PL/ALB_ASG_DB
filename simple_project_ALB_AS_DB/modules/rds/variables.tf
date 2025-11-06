variable "vpc_id" {
    description = "ID VPC for RD and Subnet Group"
    type = string
  
}

variable "private_subnet_ids" {
    description = "List ID private subnets"
    type = list(string)
  
}

variable "db_instance_class" {
    description = "Type of instance RDS"
    type = string
  
}

variable "db_name" {
    description = "Name of DB"
    type = string
    default = "appDB"
  
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