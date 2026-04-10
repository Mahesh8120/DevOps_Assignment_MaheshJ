terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-mahesh" # my own s3 bucket
    key          = "terraform.tfstate-resources-s3"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}

provider "aws" {
   alias  = "us_east_1"
   region = "us-east-1"
  
}