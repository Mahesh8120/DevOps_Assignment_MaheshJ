# Secure Public Bucket Storage Architecture (AWS)

## 📌 Objective

Design and implement a secure architecture to serve public static content from object storage while:

* Preventing direct access to storage URLs
* Enforcing strict access controls
* Ensuring scalability for high request volumes
* Routing all traffic through a load balancer

---

## 🏗️ Architecture Overview

This solution uses the following AWS services:

* Amazon CloudFront (CDN)
* Application Load Balancer (ALB)
* ECS Fargate (Proxy Layer)
* Amazon S3 (Private Bucket)
* IAM (Access Control)
* VPC (Network Isolation)

### 🔄 Request Flow

1. User sends request to application domain
2. DNS routes traffic to CloudFront
3. CloudFront:

   * Returns cached content (if available)
   * Otherwise forwards request to ALB
4. ALB routes traffic to ECS Fargate service
5. ECS (proxy service):

   * Authenticates using IAM role
   * Fetches object from S3 using AWS SDK
6. Response flows back through ALB → CloudFront → User
7. CloudFront caches the response

---

## 🔐 Security Design

### 1. No Direct S3 Access

* S3 bucket is fully private
* Public access is blocked at bucket level
* No public URLs are accessible

### 2. Controlled Access via Load Balancer

* All traffic must pass through:

  * CloudFront → ALB → ECS
* Direct access to ECS is restricted via security groups

### 3. IAM-Based Authentication

* ECS task uses IAM role to access S3
* No static credentials are used

---

## 🔒 Implemented Security Controls

### ✅ Bucket Policies

* Only ECS task role can read objects
* Explicit deny for `s3:ListBucket` (prevents enumeration)

### ✅ Encryption (Data at Rest)

* Server-side encryption enabled (SSE-S3)

### ✅ Versioning

* Enabled for object recovery and rollback

### ✅ Access Logging

* S3 access logs enabled
* ALB access logs enabled

### ✅ Lifecycle Policies

* Old data automatically moved to archival storage

### ✅ Hotlink Protection

* Implemented using CloudFront policies / headers

### ✅ Geo Restrictions

* Configurable via CloudFront

---

## 🌐 CDN Configuration

* CloudFront is placed in front of ALB
* Optimized caching policies:

  * Images → long TTL (24 hours)
  * CSS/JS → medium TTL (1 hour)
  * HTML → short TTL (5 minutes)

### Cache Invalidation Strategy

* Use versioned file names (recommended)
* OR manual invalidation:

  ```
  aws cloudfront create-invalidation --paths "/*"
  ```

---

## ⚙️ Infrastructure Setup (Terraform)

### Components Provisioned

* VPC with public and private subnets
* Application Load Balancer (public)
* ECS Fargate service (private subnets)
* IAM roles and policies
* Private S3 bucket
* CloudFront distribution

---

## 🚀 Deployment Steps

### 1. Initialize Terraform

```
terraform init
```

### 2. Plan Infrastructure

```
terraform plan
```

### 3. Apply Configuration

```
terraform apply
```

### 4. Upload Static Content

```
aws s3 cp ./static-site s3://<bucket-name>/ --recursive
```

---

## 🧪 Testing

### Health Check

```
GET /health
```

### Fetch Content

```
GET /files/<filename>
```

### Validation

* Direct S3 URL → ❌ Access Denied
* CloudFront URL → ✅ Works

---

## 📈 Performance Considerations

* CloudFront handles global caching
* ECS scales horizontally (Fargate auto-scaling)
* S3 provides virtually unlimited scalability

---

## 💰 Cost Optimization

* CDN caching reduces backend load
* Lifecycle policies reduce storage costs
* Minimal ECS resources used (optimized CPU/memory)
* Optional: Use Fargate Spot for lower cost

---

## ⚠️ Design Considerations

### Why ECS Proxy?

Application Load Balancer cannot directly authenticate to S3.

To meet the requirement:

> “Load balancer must authenticate to backend bucket”

We introduced ECS Fargate as a secure proxy layer that:

* Uses IAM role for authentication
* Fetches objects from S3
* Returns responses to ALB

---

## 🔄 Alternative Approach (Optimization)

In real-world production systems, this architecture can be simplified:

* Replace ALB + ECS with direct CloudFront → S3 integration
* Use Origin Access Control (OAC)

This reduces:

* Latency
* Cost
* Complexity

---

## 📊 Cost Estimate (Approximate)

| Component   | Cost Driver              |
| ----------- | ------------------------ |
| CloudFront  | Data transfer + requests |
| ECS Fargate | CPU + memory usage       |
| ALB         | LCU usage                |
| S3          | Storage + GET requests   |

---

## 📌 Conclusion

This architecture:

* Ensures **no direct access to S3**
* Enforces **strict access via load balancer**
* Supports **high scalability (thousands of requests/sec)**
* Implements **multiple security best practices**
* Fully satisfies all assignment requirements

---

## 📎 Deliverables Included

* Terraform code
* Architecture diagram
* Secure S3 configuration
* Load balancer setup
* CDN configuration
* Security controls implementation

---
