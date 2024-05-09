# EKS required to spread workload to at least 2 availability zones
# Private subnet is for Kubernetes Cluster, public subnet is for Load Balancer

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone
  cidr_block = "192.168.0.0/18"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" # make this subnet become discoverable by EKS
    "kubernetes.io/role/elb" = "1" # make this subnet available for Load Balancer
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone2
  cidr_block = "192.168.64.0/18"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" # make this subnet become discoverable by EKS
    "kubernetes.io/role/elb" = "1" # make this subnet available for Load Balancer
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone
  cidr_block = "192.168.128.0/18"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1" # make this subnet available for internal Load Balancer
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone2
  cidr_block = "192.168.192.0/18"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-2"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1" # make this subnet available for internal Load Balancer
  }
}

