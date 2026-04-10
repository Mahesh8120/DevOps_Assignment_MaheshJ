# Secure Public Bucket Storage (AWS)

## 📌 Overview

This project implements a secure architecture for serving static content using AWS services while preventing direct access to storage.

---

## 🏗 Architecture

* Amazon CloudFront (CDN + Load Balancer layer)
* Private Amazon S3 Bucket
* Route53 DNS

---

## 🔐 Security Controls

### 1. Access Control

* S3 bucket is private
* Public access blocked
* Only CloudFront can access via OAC (SigV4)

### 2. Signed URLs

* CloudFront signed URLs enabled
* Restricts user-level access

### 3. Encryption

* Server-side encryption (AES256)

### 4. Versioning

* Enabled for recovery and rollback

### 5. Logging

* Access logs stored in separate S3 bucket

### 6. Lifecycle Policy

* Objects expire after 30 days

### 7. Geo Restriction

* Access restricted to specific regions

---

## 🚀 Setup Instructions

### 1. Initialize Terraform

```
terraform init
```

### 2. Apply Infrastructure

```
terraform apply -auto-approve
```

### 3. Upload Static Content

Ensure files exist:

```
content/index.html
content/style.css
```

### 4. Access Application

Use:

* CloudFront URL OR
* Custom domain (Route53)

---

## 🔄 Cache Invalidation Strategy

* Preferred: versioned files (e.g., style.v1.css)
* Alternative: manual invalidation via AWS CLI

---

## ⚡ Performance Optimization

* CloudFront edge caching
* Optimized cache policy
* Reduced origin calls

---

## 💰 Cost Optimization

* S3 lifecycle policies reduce storage cost
* CloudFront caching reduces data transfer
* No EC2 → lower compute cost

---

## ✅ Outcome

* Secure content delivery
* High scalability
* No direct S3 access
* Optimized performance and cost
