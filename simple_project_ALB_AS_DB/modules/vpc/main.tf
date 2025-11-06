# VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "VPC-${var.env_tag}"
      Environment = "var.env_tag"
    }
  
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      Name = "IGW-${var.env_tag}"
    }
  
}
# data source
data "aws_availability_zones" "available" {
  state = "available"
  
}

# Public subnets
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = element(data.aws_availability_zones.available.names, count.index)
    map_public_ip_on_launch = true

    tags = {
      Name = "Public-Subnet-${element(data.aws_availability_zones.available.names, count.index)}"

    }
  
}

# Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private-Subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
  
}
# Elastic IP
resource "aws_eip" "nat" {
  count = length(aws_subnet.public)
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]
  
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat[count.index].id

  tags = {
    Name = "NAT-Gateway-${count.index}"
  }
  
}
# Route Table Public
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id

    }

    tags = {
      Name = "Public-Route-Table-${var.env_tag}"
    }
  
}

# Association 
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.rt.id
  
}

# Route Table Private
resource "aws_route_table" "priv_rt" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "Private-Route-Table-${count.index}"
  }
  
}

# Association 
resource "aws_route_table_association" "assoc_priv" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.priv_rt[count.index].id
  
}