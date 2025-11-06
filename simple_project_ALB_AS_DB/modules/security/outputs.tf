output "alb_sg_id" {
    description = "ID SG for Load Balancer"
    value = aws_security_group.alb_sg.id
  
}

output "instance_sg_id" {
    description = "ID SG for backand instance (ASG)"
    value = aws_security_group.instance_sg.id
  
}

output "backend_app_port" {
    description = "The port on which the backend application is running"
    value = var.backend_app_port
  
}