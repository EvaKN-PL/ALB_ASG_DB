# SG for RDS
resource "aws_security_group" "db_sg" {
    name = "rds-db-sg"
    description = "Access to DB only from instance"
    vpc_id = var.vpc_id
  
}

# RDS Subnet group
resource "aws_db_subnet_group" "subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = var.private_subnet_ids

    tags = {
        Name = "RDS Subnet Group"

    }
  
}

# Db instance (PostgresSQL)
resource "aws_db_instance" "db_rds" {
    allocated_storage = 20
    storage_type = "gp2"
    engine = "postgres"
    engine_version = "17.6"
    instance_class = var.db_instance_class
    identifier = var.db_name
    username = var.db_username
    password = var.db_password
    db_name = var.db_name
    vpc_security_group_ids = [ aws_security_group.db_sg.id ]
    db_subnet_group_name = aws_db_subnet_group.subnet_group.id
    skip_final_snapshot = true # only for test
    publicly_accessible = false
    multi_az = true
    
}