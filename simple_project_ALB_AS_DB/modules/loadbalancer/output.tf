output "dns_name" {
    description = "DNS name ALB"
    value = aws_alb.main.dns_name
  
}

output "target_group_arn" {
    description = "ARN of Target Group for Auto Scaling Group"
    value = aws_lb_target_group.alb_tg.arn
  
}