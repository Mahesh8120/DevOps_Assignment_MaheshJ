# 📦 DevOps Assignment Submission

## 👤 Candidate Details

* **Name:** Mahesh Jonnalagadda
* **Email:** jonnalagaddamahi@gmail.com
* **Phone:** +91-7032578316

---

## 🔗 Repository Links

* **Case 1 (Application + CI/CD):** https://github.com/Mahesh8120/DevOps_Assignment_MaheshJ/tree/main/case-1

* **Case 2 (Secure Static Content):** https://github.com/Mahesh8120/DevOps_Assignment_MaheshJ/tree/main/case-2

---

## 🌐 Live Endpoints

* **Case 1 Application URL:** Not available (infrastructure has been decommissioned after testing)
* **Case 2 Static Website (CloudFront URL):** Not available (infrastructure has been decommissioned after testing)

> ⚠️ Note: Due to AWS Free Tier limitations and cost constraints, all resources were destroyed after successful deployment and validation.
> Screenshots and configuration proofs are provided in the repository for verification.


---

# 🧩 Case 1: Application Deployment with CI/CD

* **Case 1 (Application + CI/CD):** https://github.com/Mahesh8120/DevOps_Assignment_MaheshJ/tree/main/case-1

## 🚀 Implementation Summary

* Containerized application using Docker
* CI/CD pipeline implemented using Jenkins CI/CD
* Automated build, test, and deployment workflow
* Deployment target: ECS 

## 🔧 Key Features

* Automated builds on code push
* Docker image versioning
* Secure deployment using IAM roles
* Infrastructure optionally provisioned using Terraform

---

# 🔐 Case 2: Secure Public Bucket Storage

* **Case 2 (Secure Static Content):** https://github.com/Mahesh8120/DevOps_Assignment_MaheshJ/tree/main/case-2


## 🏗 Architecture Overview

* Static content stored in private **S3 bucket**
* Content delivered via **CloudFront (CDN + Load Balancer layer)**
* DNS configured using Route53
* Secure access enforced using Origin Access Control (OAC)

## 🔐 Security Implementation

### 1. Access Control

* S3 bucket is private (no public access)
* Direct object access blocked
* Only CloudFront can access S3 via OAC (SigV4)

### 2. Signed URL Mechanism

* CloudFront signed URLs enabled
* Ensures secure and controlled access to content

### 3. Encryption

* Server-side encryption enabled (AES-256)

### 4. Versioning

* Enabled for recovery and rollback

### 5. Logging

* Access logs enabled and stored in separate S3 bucket

### 6. Lifecycle Policy

* Objects automatically expire after 30 days

### 7. Geo Restriction

* Access restricted to selected regions

---

## ⚙️ Implementation Approach

* Infrastructure provisioned using Terraform
* Static files (HTML, CSS) uploaded to S3
* CloudFront configured with:

  * OAC for secure origin access
  * Optimized caching policy
  * HTTPS enforcement
* Route53 used for DNS mapping

---

## ⚡ Performance Optimization

* CloudFront edge caching reduces latency
* Managed cache policies improve response time
* Reduces load on S3 origin

---

## 💰 Cost Optimization

* No EC2 instances used (serverless architecture)
* Lifecycle policies reduce storage cost
* CDN caching reduces data transfer and requests

---


## 📸 Proof of Configuration

Screenshots included in repository:

* S3 bucket configuration (permissions, encryption, versioning)
* CloudFront distribution (origin, cache behavior)
* Route53 DNS records
* Security configurations (OAC, geo restrictions)

---

# 🧠 Key Design Decision

Although the requirement mentions a "Load Balancer", in AWS:

* **CloudFront acts as both CDN and load balancing layer**
* Application Load Balancer cannot directly integrate with S3
* Therefore, CloudFront is used to securely and efficiently deliver static content at scale

---

# ✅ Conclusion

* Secure architecture implemented with strict access controls
* High scalability using CDN edge network
* Optimized for performance and cost
* Fully aligned with cloud best practices

---

**Thank you for reviewing my submission!**
