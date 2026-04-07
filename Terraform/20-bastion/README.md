# Terraform / Bastion Host

This module creates the following resources:

* EC2 instance (Bastion Host)
* Bastion host in a public subnet
* Security Group attached from SSM Parameter Store
* Root volume (50GB gp3)
* User data script execution during instance launch
* Installation of Docker, kubectl, eksctl, and Helm
* Disk expansion for `/home` directory

---

### Example Creation

This module creates a single Bastion host:

```
Name: particle41-dev-bastion
```

---

### How It Works

* Reads required values from SSM Parameter Store
* Uses public subnet for internet access
* Attaches Security Group dynamically
* Executes `user_data` script during launch
* Installs DevOps tools automatically

---

### Inputs

* project_name - (Required) Name of the project
* environment - (Required) Environment name (dev/stage/prod)
* ami_id - (Required) AMI ID for EC2 instance
* bastion_sg_id - (Required) Security Group ID (from SSM)
* public_subnet_ids - (Required) Public subnet IDs (from SSM)

---

### Output Format

Bastion instance will be created with naming pattern:

```
<project_name>-<environment>-bastion
```

Example:

```
particle41-dev-bastion
```

---

### Summary

This module helps you:

* Create a ready-to-use Bastion host
* Automate installation of DevOps tools
* Securely access private infrastructure
* Avoid manual configuration after launch

---

### In One Line

👉 "Creates a Bastion EC2 instance in a public subnet with pre-installed DevOps tools for infrastructure and Kubernetes management."
