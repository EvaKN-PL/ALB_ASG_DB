# ALB_ASG_DB
# AWS 3-Tier Highly Available Architecture (Multi-AZ) with Terraform

This project contains a complete, modular infrastructure configuration on the AWS platform, implemented using Terraform. The architecture is based on a secure 3-Tier pattern (Web, App, Data) with full resilience against single Availability Zone (AZ) failure (Multi-AZ).

## 📐 Logical Architecture

The infrastructure is divided into public and private subnets, ensuring separation of public resources (Load Balancer) from private ones (Web Instances, Database).

### Components Summary

| Layer | Resource | Location | Purpose |
| :--- | :--- | :--- | :--- |
| **Network (VPC)** | 2x Public Subnets, 2x Private Subnets | Multi-AZ | AZ Failure resilience. |
| **Inbound** | Application Load Balancer (ALB) | Public | Distributes traffic to the Auto Scaling Group (ASG). |
| **Application** | Auto Scaling Group (ASG), 2x EC2 | **Private** | Maintains a minimum of 2 active Web Server instances. |
| **Outbound** | 2x NAT Gateway | Public | Allows private instances to access the internet securely. |
| **Data** | RDS PostgreSQL | **Private** | Managed database service with **Multi-AZ** replication. |

### Architecture Diagram

<img width="889" height="525" alt="ALB-ASG-DB drawio(1)" src="https://github.com/user-attachments/assets/9df00d04-6542-4049-b06b-5dc198dbae68" />
