# VPC
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The primary CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# # Internet Gateway
# output "igw_id" {
#   description = "ID of the Internet Gateway"
#   value       = module.igw.igw_id
# }

# # NAT Gateway
# output "nat_gateway_id" {
#   description = "ID of the NAT Gateway"
#   value       = module.nat.nat_gateway_id
# }

# # Subnets
# output "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   value       = module.public_subnet.public_subnet_ids
# }

# output "public_subnet_cidrs" {
#   description = "CIDR blocks of public subnets"
#   value       = module.public_subnet.public_subnets_cidr
# }

# # Route Tables
# output "public_route_table_id" {
#   description = "Public Route Table ID"
#   value       = module.public_route_table.route_table_id
# }

# # Security Group
# output "security_group_id" {
#   description = "Value of the security group ID"
#   value       = module.security_group.security_group_id
# }

# # IAM Roles
# output "eks_cluster_role_arn" {
#   description = "ARN of the IAM role created for the EKS Cluster control plane"
#   value       = module.iam.eks_cluster_role_arn
# }

# output "eks_node_group_role_arn" {
#   description = "ARN of the IAM role created for the EKS Node Group (workers)"
#   value       = module.iam.eks_node_group_role_arn
# }


# ############################################################################################################

# # ################################################################################
# # IAM Outputs
# # ################################################################################

# output "alb_controller_role_arn" {
#   description = "The ARN of the IAM role for the ALB controller"
#   value       = module.alb-controller-iam.role_arn
# }

# output "alb_controller_role_name" {
#   description = "The name of the IAM role for the ALB controller"
#   value       = module.alb-controller-iam.role_name
# }

# output "alb_controller_policy_arn" {
#   description = "The ARN of the IAM policy for the ALB controller"
#   value       = module.alb-controller-iam.policy_arn
# }

# # ################################################################################
# # Kubernetes Outputs
# # ################################################################################

# output "alb_controller_service_account_name" {
#   description = "The name of the Kubernetes service account for the ALB controller"
#   value       = module.k8s_resources.service_account_name
# }

# output "alb_controller_namespace" {
#   description = "The namespace where the ALB controller is deployed"
#   value       = module.k8s_resources.namespace
# }

# # ################################################################################
# # Helm Outputs
# # ################################################################################

# output "helm_release_name" {
#   description = "The name of the Helm release"
#   value       = module.helm_chart.release_name
# }

# output "helm_release_status" {
#   description = "The status of the Helm release"
#   value       = module.helm_chart.release_status
# }

# output "helm_chart_version" {
#   description = "The version of the deployed Helm chart"
#   value       = module.helm_chart.chart_version
# }
