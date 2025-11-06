# SG for ALB - public access
resource "aws_security_group" "alb_sg" {
    name = "alb-traffic-sg"
    description = "Allow traffic HTTP from internet"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.alb_ingress_ports
        content {
          description = "Access to port ${ingress.value} from Internet"
          from_port = ingress.value
          to_port = ingress.value
          protocol = "tcp"
          cidr_blocks = [ "0.0.0.0/0" ]
        }
      
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}

# SG for instance EC2/ASG - Traffic only for ALB and SSH
resource "aws_security_group" "instance_sg" {
    name = "backend-instance-sg"
    description = "Allow traffic from ALB and SSH"
    vpc_id = var.vpc_id

    ingress {
        description = "Application traffic from ALB"
        from_port = var.backend_app_port
        to_port = var.backend_app_port
        protocol = "tcp"
        # placeholder
        security_groups = []
    }

    ingress { # For production environment, access only from trusted IP!
        description = "SSH access for Administrator"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

