# allocate Elastic IP for NAT Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "onxp-nat-eip" {
  depends_on = [ aws_internet_gateway.onxp-igw ]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "onxp-nat-1" {
  allocation_id = aws_eip.onxp-nat-eip.id

  # nat gateway should be in public subnet, so it can access internet
  subnet_id = aws_subnet.public-subnet-1.id

  tags = {
    Name = "OnXP Nat Gateway - Public Subnet 1"
  }

  depends_on = [aws_internet_gateway.onxp-igw]
}

resource "aws_nat_gateway" "onxp-nat-2" {
  allocation_id = aws_eip.onxp-nat-eip.id

  # nat gateway should be in public subnet, so it can access internet
  subnet_id = aws_subnet.public-subnet-2.id

  tags = {
    Name = "OnXP Nat Gateway - Public Subnet 2"
  }

  depends_on = [aws_internet_gateway.onxp-igw]
}