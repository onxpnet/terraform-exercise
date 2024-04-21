# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  # can be "dedicated" or "default". Use default for multi-tenant, more cheaper
  instance_tenancy = "default"

  # default is false
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}