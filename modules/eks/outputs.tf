# ---------------------------------------------------------------------
# Outputs for EKS Module
# ---------------------------------------------------------------------
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.this.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_id" {
  description = "EKS Node Group ID"
  value       = aws_eks_node_group.this.id
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enable_irsa = true"
  value       = try(aws_iam_openid_connect_provider.this.arn, "")
}

output "oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OIDC Identity Provider"
  value       = try(aws_iam_openid_connect_provider.this.url, "")
}

output "ebs_csi_role_arn" {
  description = "The ARN of the IAM role for the EBS CSI driver (IRSA)"
  value       = aws_iam_role.ebs_csi_role.arn
}
