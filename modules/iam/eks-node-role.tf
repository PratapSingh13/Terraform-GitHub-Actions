/*
──────────────────────────────────────────────────────────────────────
IAM Role for EKS Node Group – IAM Module
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Create the IAM Role used by EKS Worker Nodes (EC2 instances).
            It allows the kubelet daemon to communicate with the EKS
            control plane and manage networking/container registry access.
📅 Created: 14‑01‑2026
👤 Owner:   Yogendra Pratap Singh (yogendra.singh01@nagarro.com)
🏢 Team:    Infrastructure / DevOps
🌍 Region:  ${var.aws_region}
🗂️ Components:
  • aws_iam_role "eks_node_role"
  • aws_iam_role_policy_attachment (WorkerNodePolicy, CNI_Policy, ECR_ReadOnly)
🔗 References:
  – EKS Node IAM Role: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
  – Terraform AWS Provider (IAM): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
🔐 Security / Compliance:
  • Principle is `ec2.amazonaws.com` (for standard EC2 nodes).
  • Grants read-only access to ECR for pulling images.
  • Grants CNI permissions for VPC networking.
📦 Inputs (variables) – see variables.tf:
  • project, environment – used for naming and tagging.
  • tags – additional tags map.
📤 Outputs – see output.tf:
  • eks_node_group_role_arn
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# aws_iam_role "eks_node_role"
# ---------------------------------------------------------------------
# The IAM role that worker nodes assume. Trust policy allows `ec2.amazonaws.com`.
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project}-${var.environment}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.project}-${var.environment}-eks-node-role"
      Environment = var.environment
    }
  )
}

# ---------------------------------------------------------------------
# Policy Attachments
# ---------------------------------------------------------------------

# 1. AmazonEKSWorkerNodePolicy: connecting to the EKS cluster API
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# 2. AmazonEKS_CNI_Policy: managing VPC networking (IPs) for pods
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# 3. AmazonEC2ContainerRegistryReadOnly: creating/pulling container images
resource "aws_iam_role_policy_attachment" "eks_ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# 4. AmazonEBSCSIDriverPolicy: allowed to manage EBS volumes
resource "aws_iam_role_policy_attachment" "eks_ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_node_role.name
}
