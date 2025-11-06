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

The diagram below illustrates the network topology, including the separation across Availability Zones (AZ-A, AZ-B) and the traffic flow.
```
graph LR
    subgraph Internet
        User(Użytkownik) --> ALB_DNS(Adres DNS ALB)
    end
    subgraph AWS Cloud (Region)
        subgraph VPC (10.0.0.0/16)
            subgraph Public Subnets (AZ-A, AZ-B)
                ALB{Application Load Balancer}
                IGW[Internet Gateway]
                NAT-A[NAT Gateway A]
                NAT-B[NAT Gateway B]
            end
            subgraph Private Subnets (AZ-A, AZ-B)
                direction LR
                ASG_A[ASG Instancja 1]
                ASG_B[ASG Instancja 2]
                RDS_PR[RDS Primary DB]
                RDS_ST[RDS Standby DB]
            end
            ALB_DNS --> ALB
            ALB --> ASG_A
            ALB --> ASG_B
            ASG_A --> RDS_PR
            ASG_B --> RDS_PR
            RDS_PR <--> RDS_ST
            ASG_A --> NAT-A
            ASG_B --> NAT-B
            NAT-A --> IGW
            NAT-B --> IGW
        end
    end
    style ALB fill:#00CCFF,stroke:#333
    style ASG_A fill:#CCFFCC,stroke:#333
    style ASG_B fill:#CCFFCC,stroke:#333
    style RDS_PR fill:#FFCC99,stroke:#333
    style RDS_ST fill:#FFCC99,stroke:#333
```
