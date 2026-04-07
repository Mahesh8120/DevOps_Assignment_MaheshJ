terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-mahesh" # my own s3 bucket
    key          = "terraform.tfstate-rules"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}

provider "aws" {
  region = "us-east-1"
}