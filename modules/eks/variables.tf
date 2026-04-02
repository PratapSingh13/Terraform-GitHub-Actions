# ---------------------------------------------------------------------
# Input Variables for EKS Module
# ---------------------------------------------------------------------

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "Name of the EKS cluster (will be prefixed with project-env)"
  type        = string
  default     = "eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster and node group"
  type        = list(string)
}

variable "iam_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS Cluster"
  type        = string
}

variable "iam_node_role_arn" {
  description = "ARN of the IAM role for the EKS Node Group"
  type        = string
}

variable "scaling_config" {
  description = "Scaling configuration for the node group"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
  default = {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to attach to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "admin_roles" {
  description = "IAM roles with cluster admin access"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the cluster."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the cluster."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
