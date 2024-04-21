# allocate Elastic IP for NAT Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "onxp-nat-eip" {
  depends_on = [ aws_internet_gateway.onxp-gw ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "onxp-nat" {
  allocation_id = aws_eip.onxp-nat-eip.id

  # nat gateway should be in public subnet, so it can access internet
  subnet_id = aws_subnet.public-subnet.id

  tags = {
    Name = "OnXP Nat Gateway"
  }

  depends_on = [aws_internet_gateway.onxp-gw]
}