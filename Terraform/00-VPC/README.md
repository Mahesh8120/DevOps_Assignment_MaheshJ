# Terraform / VPC

This module creates the following resources.
* VPC
* IGW
* 2 Public subnets in us-east-1a and us-east-1b AZ
* 2 Private subnets in us-east-1a and us-east-1b AZ

* Public Route table
* Private Route table

* EIP for NAT
* NAT Gateway in public subnet 1a az
* IGW route is added to public route table
* NAT gateway route to private tables
* Route table association with subnets



### Inputs

* vpc_cidr - (Required). User must supply the CIDR for VPC.
* project_name - (Required). User must supply the project nae.





👤 Author

Mahesh
DevOps Engineer | AWS | Kubernetes | Terraform