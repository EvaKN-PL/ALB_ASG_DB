output "db_hostname" {
    description = "Endpoint data base RDS"
    value = aws_db_instance.db_rds.address
  
}

output "db_sg_id" {
    description = "ID Security Group of RDS"
    value = aws_security_group.db_sg.id
  
}