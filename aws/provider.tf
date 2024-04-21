terraform {

  # https://developer.hashicorp.com/terraform/language/settings/backends/s3
  backend "s3" {
    bucket = "onxp-terraform"
    key    = "terraform/state"
    region = var.region
  }

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