# ################################################################################
# IAM Outputs
# ################################################################################

output "role_arn" {
  description = "ARN of the IAM role for the ALB controller"
  value       = aws_iam_role.alb-controller-iam.arn
}

output "role_name" {
  description = "Name of the IAM role for the ALB controller"
  value       = aws_iam_role.alb-controller-iam.name
}

output "policy_arn" {
  description = "ARN of the IAM policy for the ALB controller"
  value       = aws_iam_policy.alb-controller-iam-policy.arn
}
