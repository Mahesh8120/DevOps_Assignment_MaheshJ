# Terraform / EKS

# 🚀 AWS EKS Cluster Setup (Terraform)

This module provisions an **Amazon EKS (Elastic Kubernetes Service)** cluster using the official Terraform module.

It includes:
- Managed Kubernetes control plane
- Managed node groups
- Core add-ons (CoreDNS, VPC CNI, kube-proxy, metrics-server)
- Secure networking using private subnets
- IAM integrations for storage drivers

---

## 📌 Module Source

Terraform module used:

- `terraform-aws-modules/eks/aws` (version ~> 21.0)

---

## ⚙️ Configuration Overview

### 🔹 Cluster Configuration

- **Cluster Name**: Derived from `local.common_name_suffix`
- **Kubernetes Version**: Controlled via `var.eks_version`
- **Endpoint Access**: Private only (`endpoint_public_access = false`)
- **Admin Permissions**: Enabled for cluster creator

---

### 🔹 Add-ons Enabled

| Add-on                    | Purpose |
|--------------------------|--------|
| CoreDNS                  | DNS resolution inside cluster |
| VPC CNI                  | Pod networking |
| kube-proxy               | Network proxy |
| metrics-server           | Resource metrics for autoscaling |
| EKS Pod Identity Agent   | IAM role access for pods |

> `before_compute = true` ensures required components are installed before node groups.

---

### 🔹 Networking

- Uses **existing VPC**
- Deploys cluster in **private subnets**
- Control plane also runs in private subnets

```hcl
vpc_id                   = local.vpc_id
subnet_ids               = local.private_subnet_ids
control_plane_subnet_ids = local.private_subnet_ids


👤 Author

Mahesh
DevOps Engineer | AWS | Kubernetes | Terraform