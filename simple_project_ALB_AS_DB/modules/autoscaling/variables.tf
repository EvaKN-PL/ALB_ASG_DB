variable "vpc_zone_identifier" {
    description = "List of subnet IDs where ASG will run instances"
    type = list(string)
  
}

variable "target_group_arn" {
    description = "ARN Target Group ALB, to which ASG will register instances"
    type = string
  
}

variable "key_name" {
    description = "Name of existing SSH key in AWS for EC2"
    type = string
}

variable "instance_type" {
    description = "Type of instance EC2"
    type = string
  
}

variable "security_group_ids" {
    description = "List of Security Group IDs for ASG instances"
    type = list(string)
  
}
