# Create route tables for public and private subnets

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "onxp-public-route-table" {
  vpc_id = aws_vpc.main.id

  # route internet eaccess to internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onxp-igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "onxp-private-1-route-table" {
  vpc_id = aws_vpc.main.id

  # route internet eaccess to nat gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.onxp-nat-1.id
  }

  tags = {
    Name = "Private Route Table - Public Subnet 1"
  }
}

resource "aws_route_table" "onxp-private-2-route-table" {
  vpc_id = aws_vpc.main.id

  # route internet access to nat gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.onxp-nat-2.id
  }

  tags = {
    Name = "Private Route Table - Public Subnet 2"
  }
}

# Associate route tables with subnets
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "onxp-public-1-subnet-association" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.onxp-public-route-table.id
}

resource "aws_route_table_association" "onxp-public-2-subnet-association" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.onxp-public-route-table.id
}


resource "aws_route_table_association" "onxp-private-1-subnet-association" {
  subnet_id = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.onxp-private-1-route-table.id
}

resource "aws_route_table_association" "onxp-private-2-subnet-association" {
  subnet_id = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.onxp-private-2-route-table.id
}