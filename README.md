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

<img width="700" height="400" alt="ALB-ASG-DB drawio(1)" src="https://github.com/user-attachments/assets/9df00d04-6542-4049-b06b-5dc198dbae68" />

🛠️ Requirements

  1. Terraform CLI: Version 1.0+

  2. AWS Account: Configured with credentials (IAM User/Role) that have appropriate permissions.

  3. `terraform.tfvars` file: Input variables must be defined (see the Configuration section).

⚙️ Variables Configuration

Before deploying, complete the terraform.tfvars file in the root directory with your required values.

```
# Example minimal configuration in terraform.tfvars

region = "eu-west-1"
env_tag = "prod"

# --- Network ---
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# --- EC2/ASG ---
instance_type = "t3.micro"
key_name = "your-ssh-key-pair-name" # The name of your SSH key in AWS

# --- RDS ---
db_username = "app_admin"
db_password = "very_secure_password"
db_instance_class = "db.t3.micro"
```

🚀 Deployment Instructions

1. Initialization and Validation

Run the following commands in the project's root directory:
```
# Initialize the backend, providers, and modules
terraform init 

# Validate the syntax and dependencies
terraform validate 

# Display the deployment plan (check what will be created)
terraform plan
```
2. Applying the Configuration

Execute the process to create the infrastructure. WARNING: This command deploys PAID resources (ALB, NAT Gateway, Multi-AZ RDS). Deployment takes approximately 15-20 minutes.

```
terraform apply --auto-approve
```
3. Verification (Post-Deployment)

After successful completion of the apply process, you can check the exported values:

```
# DNS Address of the Load Balancer (application access)
terraform output alb_dns_name

# Database endpoint (used by the application)
terraform output db_hostname
```
⚠️ Infrastructure Removal (Crucial for Cost Control)

To avoid recurring charges, it is critical to completely destroy all resources after testing is complete.

```
# This command destroys all resources managed by this project
terraform destroy --auto-approve
```
