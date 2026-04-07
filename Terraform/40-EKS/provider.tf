terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-mahesh"  # my own s3 bucket
    key          = "terraform.tfstate-eks"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}

provider "aws" {
  region = "us-east-1"
}
