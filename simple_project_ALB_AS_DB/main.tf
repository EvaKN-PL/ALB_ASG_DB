terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"

}

provider "aws" {

    region = var.aws_region
  
}

# Calling the VPC module

module "network" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    env_tag = "dev"
}

# Calling the security module
module "security" {
    source = "./modules/security"
    vpc_id = module.network.vpc_id
    alb_ingress_ports = [80]
    backend_app_port = 80

  
}

# Calling load balancer module (ALB)
module "alb" {
  source = "./modules/loadbalancer"
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_ids = [module.security.alb_sg_id]
  
}

# Calling Auto Scaling Group module (ASG)
module "asg" {
  source = "./modules/autoscaling"
  vpc_zone_identifier = module.network.private_subnet_ids
  target_group_arn = module.alb.target_group_arn
  key_name            = var.key_name 
  instance_type       = var.instance_type
  security_group_ids  = [module.security.instance_sg_id]
  
}
resource "aws_security_group_rule" "allow_alb_to_sg" {
  type = "ingress"
  from_port = module.security.backend_app_port
  to_port = module.security.backend_app_port
  protocol = "tcp"
  # Target: SG instance ASG
  security_group_id = module.security.instance_sg_id
  # Source: SG Load Balancer (Only ALB can connect)
  source_security_group_id = module.security.alb_sg_id
  description = "Allowing traffic from ALB to backend instances"
  
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_username = var.db_username
  db_password = var.db_password
  db_instance_class = var.db_instance_class
  db_name = var.db_name
  
}
# Permission to move FROM ASG TO RDS
resource "aws_security_group_rule" "allow_asg_to_rds" {
  type = "ingress"
  from_port = 5432
  to_port = 5432
  protocol = "tcp"
  security_group_id = module.rds.db_sg_id
  source_security_group_id = module.security.instance_sg_id
  description = "Allow PostgreSQL traffic from application instance to RDS"
  
}