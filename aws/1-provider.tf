terraform {

  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  # If you want to use S3 as backend, uncomment this block
  # backend "s3" {
  #   bucket = "onxp-terraform"
  #   key    = "terraform/state"
  #   region = "us-east-1"
  # }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  profile = "onxp"
  region = "us-east-1"
}