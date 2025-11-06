# ALB
resource "aws_alb" "main" {
    name = var.alb_name
    internal = false
    load_balancer_type = "application"
    security_groups = var.security_group_ids
    subnets = var.public_subnet_ids

    enable_deletion_protection = false

    tags = {
      Name = var.alb_name
    }
  
}

# Target Group
resource "aws_lb_target_group" "alb_tg" {
    name = "${var.alb_name}-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "instance"

    health_check {
      path = "/"
      port = "traffic-port"
      protocol = "HTTP"
      matcher = "200"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
      
    } 
}

# Listener
resource "aws_lb_listener" "alb-lt" {
    load_balancer_arn = aws_alb.main.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_tg.arn
    }
}