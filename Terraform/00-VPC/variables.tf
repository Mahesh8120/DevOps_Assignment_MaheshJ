

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  default = {
    Name       = "particle41"
    Purpose    = "vpc-module-test"
   
  }
}

variable "project_name" {
  default = "particle41"
}

variable "environment" {
  default = "dev"
}
variable "igw_tags" {
  default = {
    Name = "particle41-igw"
  }
}

variable "public_subnet_cidrs" {
    default= ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
    default= ["10.0.11.0/24","10.0.12.0/24"]
}



variable "public_subnet_tags" {
    type = map
    default = {}
}


variable "private_subnet_tags" {
    type = map
    default = {}
}



variable "public_route_table_tags" {
    type = map
    default = {}
}

variable "private_route_table_tags" {
    type = map
    default = {}
}



variable "eip_tags" {
    type = map
    default = {}
}

variable "nat_gateway_tags" {
    type = map
    default = {}
}

