# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# Create role for node group
resource "aws_iam_role" "onxp-eks-node" {
  name = "onxp-eks-node"    
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# attach role to policy
resource "aws_iam_role_policy_attachment" "aws-eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.onxp-eks-node.name
}

resource "aws_iam_role_policy_attachment" "aws-eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.onxp-eks-node.name
}

resource "aws_iam_role_policy_attachment" "aws-eks-container-registry-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.onxp-eks-node.name
}