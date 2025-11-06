# ID_VPC
output "vpc_id" {
    description = "Id VPC"
    value = aws_vpc.my_vpc.id
  
}

# ID Public Subnets
output "public_subnet_ids" {
    description = "ID list of public subnets"
    value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_cidrs" {
    description = "List of ID private subnets"
    value = [for s in aws_subnet.private : s.id]
  
}

output "private_subnet_ids" {
  description = "List ID of Private subnets"
  value       = [for s in aws_subnet.private : s.id]
}