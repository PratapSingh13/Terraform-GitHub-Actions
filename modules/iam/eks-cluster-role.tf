/*
──────────────────────────────────────────────────────────────────────
IAM Role for EKS Cluster – IAM Module
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Create the IAM Role required by the EKS Control Plane
            to manage AWS resources (Load Balancers, ENIs, etc.)
            on your behalf.
📅 Created: 14‑01‑2026
👤 Owner:   Yogendra Pratap Singh (yogendra.singh01@nagarro.com)
🏢 Team:    Infrastructure / DevOps
🌍 Region:  ${var.aws_region}
🗂️ Components:
  • aws_iam_role "eks_cluster_role"
  • aws_iam_role_policy_attachment "eks_cluster_policy"
🔗 References:
  – EKS Cluster IAM Role: https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html
  – Terraform AWS Provider (IAM): https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
🔐 Security / Compliance:
  • Grants high privileges to the EKS service principally.
  • Uses the managed policy `AmazonEKSClusterPolicy`.
📦 Inputs (variables) – see variables.tf:
  • project, environment – used for naming and tagging.
  • tags – additional tags map.
📤 Outputs – see output.tf:
  • eks_cluster_role_arn
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# aws_iam_role "eks_cluster_role"
# ---------------------------------------------------------------------
# The IAM role that Kubernetes (EKS) assumes to create AWS resources.
# Trust policy allows `eks.amazonaws.com`.
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.project}-${var.environment}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name        = "${var.project}-${var.environment}-eks-cluster-role"
      Environment = var.environment
    }
  )
}

# ---------------------------------------------------------------------
# aws_iam_role_policy_attachment "eks_cluster_policy"
# ---------------------------------------------------------------------
# Attach the necessary AWS managed policy for EKS cluster operations.
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}
