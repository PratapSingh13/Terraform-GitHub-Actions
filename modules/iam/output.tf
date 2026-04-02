# ---------------------------------------------------------------------
# Outputs for IAM Module
# ---------------------------------------------------------------------

output "eks_cluster_role_arn" {
  description = "ARN of the IAM role created for the EKS Cluster control plane"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  description = "ARN of the IAM role created for the EKS Node Group (workers)"
  value       = aws_iam_role.eks_node_role.arn
}
