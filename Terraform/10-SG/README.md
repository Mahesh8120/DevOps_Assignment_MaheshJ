# Terraform / Security Groups

This module creates the following resources:

* Multiple Security Groups (based on input list)
* Each Security Group inside the specified VPC
* Security Group names dynamically from input
* Security Group descriptions automatically generated
* Tags using project name and environment

---

### Example Creation

If you provide:

```
sg_names = ["frontend", "backend", "database"]
```

👉 This will create:

* frontend Security Group
* backend Security Group
* database Security Group

---

### How It Works

* Uses `count` to create multiple resources
* `count.index` iterates through the list
* Each iteration creates one Security Group

---

### Inputs

* project_name - (Required) Name of the project
* environment - (Required) Environment name (dev/stage/prod)
* sg_names - (Required) List of security group names
* vpc_id - (Required) VPC ID where SGs will be created

---

### Output Format

Security Groups will be created with naming pattern:

```
<project_name>-<environment>-<sg_name>
```

Example:

```
particle41-dev-frontend
particle41-dev-backend
particle41-dev-database
```

---

### Summary

This module helps you:

* Create multiple security groups with minimal code
* Avoid repetition
* Maintain consistent naming
* Easily scale by adding new names to the list

---

### In One Line

👉 "Creates multiple AWS Security Groups dynamically inside a VPC using a list of names."
