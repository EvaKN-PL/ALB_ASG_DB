# Dynamically download the latest AMI ID
data "aws_ami" "latest" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["al2023-ami-*-kernel-*-x86_64"]
    }

    filter {
      name = "architecture"
      values = ["x86_64"]
    }
  
}

# Launch Template
resource "aws_launch_template" "main" {
    name_prefix = "web-server-lt-"
    image_id = data.aws_ami.latest.id
    instance_type = var.instance_type
    key_name = var.key_name

    # Network and security definition in the template
    network_interfaces {
      associate_public_ip_address = false
      security_groups = var.security_group_ids
    }

    # user data
    user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Witaj (ASG)</h1>" > /usr/share/nginx/html/index.html
              EOF
    )
  
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
    name = "web-server-asg"
    vpc_zone_identifier = var.vpc_zone_identifier

    # Configuration
    min_size = 2
    max_size = 3
    desired_capacity = 2

    target_group_arns = [var.target_group_arn]

    launch_template {
      id = aws_launch_template.main.id
      version = "$Latest"
    }

    tag {
      key = "Name"
      value = "Web-server-ASG-Instance"
      propagate_at_launch = true
    }
  
}