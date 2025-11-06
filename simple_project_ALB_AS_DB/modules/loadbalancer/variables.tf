variable "vpc_id" {
    description = "VPC ID where the ALB will be placed"
    type = string
  
}

variable "public_subnet_ids" {
    description = "List public subnets ID"
    type = list(string)
  
}

variable "security_group_ids" {
    description = "List of SG for ALB"
    type = list(string)
  
}

variable "alb_name" {
    description = "Name of ALB"
    type = string
    default = "web-app-alb"
  
}