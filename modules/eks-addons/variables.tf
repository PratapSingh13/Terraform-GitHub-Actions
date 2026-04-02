variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags for EKS add-ons"
  type        = map(string)
  default     = {}
}

variable "ebs_csi_role_arn" {
  description = "The ARN of the IAM role for the EBS CSI driver (IRSA)"
  type        = string
  default     = ""
}
