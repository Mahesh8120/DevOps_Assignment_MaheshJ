# 🚀 Case-1: Secure JWT Application Deployment (AWS ECS Fargate)

## 📌 Overview

This project demonstrates a complete **DevOps implementation** for deploying a containerized application on AWS using modern best practices.

The solution includes:

* Containerized application (Node.js)
* CI/CD pipeline using Jenkins
* Deployment on AWS ECS Fargate (serverless)
* Application Load Balancer with HTTPS
* Domain + DNS using Route53
* Security using WAF and ECR image scanning

---

## 🏗️ Architecture

                    🌐 Internet
                        │
                        ▼
                  Route53 (DNS)
                        │
                        ▼
              Application Load Balancer
                   (Public Subnets)
                        │
        ┌───────────────┼───────────────┐
        ▼                               ▼
  Public Subnet A                 Public Subnet B
        │                               │
        └───────────────┬───────────────┘
                        │
                        ▼
                Target Group (IP)
                        │
                        ▼
              ECS Fargate Service
               (Private Subnets)
        ┌───────────────┼───────────────┐
        ▼                               ▼
  Private Subnet A               Private Subnet B
        │                               │
        ▼                               ▼
   ECS Task (Container)         ECS Task (Container)
        │
        ▼
     ECR (Image Registry)


---

## ⚙️ Tech Stack

* **Cloud**: AWS
* **Compute**: ECS Fargate (Serverless)
* **Container Registry**: ECR
* **CI/CD**: Jenkins
* **Infrastructure as Code**: Terraform
* **Load Balancer**: Application Load Balancer (ALB)
* **DNS**: Route53
* **Security**: AWS WAF, ECR Image Scanning
* **Language**: Node.js (Express)

---

## 📁 Project Structure

```
case-1/
 ├── app/                  # Application source code
 ├── Infrastructure/      # Terraform code
 │    ├── vpc.tf
 │    ├── alb.tf
 │    ├── ecs.tf
 │    ├── acm.tf
 │    ├── waf.tf
 │    └── variables.tf
 ├── Jenkinsfile          # CI/CD pipeline
 └── README.md
```

---

## 🚀 Deployment Steps

### 1. Clone Repository

```
git clone <repo-url>
cd case-1
```

---

### 2. Provision Infrastructure (Terraform)

```
cd Infrastructure
terraform init
terraform plan
terraform apply
```

---

### 3. CI/CD Pipeline (Jenkins)

Pipeline stages:

* Checkout code
* Install dependencies
* Run tests
* Build Docker image
* Push image to ECR
* Scan image (ECR)
* Fail on HIGH/CRITICAL vulnerabilities
* Deploy to ECS Fargate

---

### 4. Access Application

After deployment:

👉 https://sitaram.icu

---

## 🔐 Security Best Practices Implemented

* HTTPS enabled using ACM
* HTTP → HTTPS redirection
* AWS WAF attached to ALB
* ECR image scanning enabled
* Pipeline fails on high/critical vulnerabilities
* IAM roles used for secure access (no hardcoded credentials)

---

## 🧪 Application Features

* Login endpoint (mock authentication)
* JWT token generation
* Protected API endpoint
* Health check endpoint (`/health`)

---

## 📊 CI/CD Highlights

* Automated Docker build & push
* Secure AWS credential handling via Jenkins
* Vulnerability scanning integrated into pipeline
* Zero manual deployment steps

---

## ⚠️ Key Learnings / Challenges

* Fixed ALB target group issue (`instance` → `ip` for Fargate)
* Resolved ACM certificate validation delays
* Implemented reliable ECR scan polling mechanism
* Ensured secure CI/CD credential handling

---

## 📌 Improvements (Future Work)

* Blue/Green deployment for zero downtime
* Add Trivy for pre-scan security checks
* Multi-environment setup (dev/stage/prod)
* Monitoring with CloudWatch & Prometheus
* Auto-scaling policies for ECS

---

## 👨‍💻 Author

**Mahesh Jonnalagadda**
DevOps Engineer (AWS)

---
