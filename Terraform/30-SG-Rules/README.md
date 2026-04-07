# Terraform / Security Group Rules (Bastion & EKS)

This module creates the following resources:

* Ingress rule to allow SSH access to Bastion from internet
* Ingress rule to allow Bastion to access EKS Control Plane (HTTPS)
* Ingress rule to allow Bastion to access EKS Nodes (SSH)
* Ingress rule to allow EKS Control Plane → EKS Nodes (all traffic)
* Ingress rule to allow EKS Nodes → EKS Control Plane (all traffic)
* Ingress rule to allow internal VPC traffic between EKS Nodes (pod-to-pod communication)

---

### Example Flow

👉 This setup enables:

* Laptop → Bastion (SSH - Port 22)
* Bastion → EKS Control Plane (HTTPS - Port 443)
* Bastion → EKS Nodes (SSH - Port 22)
* EKS Control Plane ↔ EKS Nodes (Full communication)
* EKS Nodes ↔ EKS Nodes (via VPC CIDR)

---

### How It Works

* Uses `aws_security_group_rule` to define granular rules
* Uses `source_security_group_id` for secure internal communication
* Uses `cidr_blocks` for external/public access
* Enables communication required for EKS cluster operations

---

### Rules Breakdown

#### 🔹 Bastion Access from Internet

* Allows SSH (22) from anywhere (`0.0.0.0/0`)
* Used to access Bastion from your laptop

#### 🔹 Bastion → EKS Control Plane

* Allows HTTPS (443)
* Required to run `kubectl` from Bastion

#### 🔹 Bastion → EKS Nodes

* Allows SSH (22)
* Used for debugging worker nodes

#### 🔹 EKS Control Plane → Nodes

* يسمح all traffic
* Required for cluster management

#### 🔹 EKS Nodes → Control Plane

* Allows all traffic
* Ensures bidirectional communication

#### 🔹 Node to Node (VPC CIDR)

* Allows all traffic within VPC (`10.0.0.0/16`)
* Required for pod-to-pod communication

---

### Inputs

* bastion_sg_id - (Required) Security Group ID of Bastion
* eks_control_plane_sg_id - (Required) EKS Control Plane SG ID
* eks_node_sg_id - (Required) EKS Node SG ID
* vpc_cidr - (Required) VPC CIDR block (e.g., 10.0.0.0/16)

---

### Summary

This module helps you:

* Securely connect Bastion with EKS
* Enable Kubernetes cluster communication
* Control traffic using least privilege (SG references)
* Support pod-to-pod networking inside VPC

---

### In One Line

👉 "Defines security group rules to enable secure communication between Bastion, EKS Control Plane, and EKS Nodes."
