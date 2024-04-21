# Create route tables for public and private subnets

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "onxp-public-route-table" {
  vpc_id = aws_vpc.main.id

  # route internet eaccess to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onxp-gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "onxp-private-route-table" {
  vpc_id = aws_vpc.main.id

  # route internet eaccess to nat gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.onxp-nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Associate route tables with subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "onxp-public-subnet-association" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.onxp-public-route-table.id
}

resource "aws_route_table_association" "onxp-private-subnet-association" {
  subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.onxp-private-route-table.id
}