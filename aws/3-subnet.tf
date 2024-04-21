# For dev purpose, create 1 public subnet and 1 private subnet
# Private subnet is for Kubernetes Cluster, public subnet is for Load Balancer
# For production, create 3 (at least 2) public subnets and 3 (at least 2) private subnets

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone
  cidr_block = "192.168.0.0/16"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared" # make this subnet become discoverable by EKS
    "kubernetes.io/role/elb" = "1" # make this subnet available for Load Balancer
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.main.id
  availability_zone = var.zone
  cidr_block = "192.168.128.0/18"

  # automatically set IP Address for EC2 instances (LB) launched in public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1" # make this subnet available for internal Load Balancer
  }
}

