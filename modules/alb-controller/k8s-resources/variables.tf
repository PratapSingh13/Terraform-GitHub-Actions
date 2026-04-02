# ################################################################################
# Kubernetes Variables
# ################################################################################

variable "namespace" {
  description = "Kubernetes namespace for the service account"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "iam_role_arn" {
  description = "ARN of the IAM role to associate with the service account"
  type        = string
}

variable "labels" {
  description = "Additional labels to add to the service account"
  type        = map(string)
  default     = {}
}
