variable "vpc_id" {
    description = "ID VPC"
    type = string
  
}

variable "alb_ingress_ports" {
    description = "List of TCP ports allowed for incoming traffic to ALB "
    type = list(number)
    default = [ 80 ]
  
}

variable "backend_app_port" {
    description = "The port on which the application is running"
    type = number
    default = 80
 
}
