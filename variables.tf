# ################################################################################
# Global Variables
# ################################################################################
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "tagName" {
  type        = string
  description = "Provide Tag Name here."
}

variable "environment" {
  description = "Environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name for the VPC"
  type        = string
}

# ################################################################################
# Variables for VPC
# ################################################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# ################################################################################
# Variables for Subnets
# ################################################################################

# variable "public_subnets_cidr" {
#   description = "CIDR blocks for public subnets"
#   type        = list(string)
# }

# variable "availability_zones" {
#   description = "List of availability zones for the public subnets"
#   type        = list(string)
# }

# variable "private_subnets_cidr" {
#   description = "CIDR blocks for private subnets"
#   type        = list(string)
# }

# # ################################################################################
# # Security Group
# # ################################################################################
# variable "create_security_group" {
#   description = "Determines if a security group is created"
#   type        = bool
# }

# variable "security_group_use_name_prefix" {
#   description = "Determines whether the security group name (`security_group_name`) is used as a prefix"
#   type        = bool
# }

# variable "security_group_tags" {
#   description = "A map of additional tags to add to the security group created"
#   type        = map(string)
#   default     = {}
# }

# variable "security_group_egress_rules" {
#   description = "Security group egress rules to add to the security group created"
#   type = map(object({
#     ip_protocol = optional(string) # protocol like tcp, udp, -1 (all)
#     from_port   = optional(number) # starting port
#     to_port     = optional(number) # ending port
#     cidr_ipv4   = optional(string) # destination CIDR
#   }))
#   default = {}
# }

# variable "security_group_ingress_rules" {
#   description = "Security group ingress rules to add to the security group created"
#   type = map(object({
#     ip_protocol = optional(string)
#     from_port   = number
#     to_port     = number
#     cidr_ipv4   = string
#   }))
#   default = {}
# }

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }
# # ################################################################################
# # EKS
# # ################################################################################
# variable "cluster_name" {
#   description = "Name of the EKS cluster (will be prefixed with project-env)"
#   type        = string
# }

# variable "cluster_version" {
#   description = "Kubernetes version to use for the EKS cluster"
#   type        = string
# }

# variable "scaling_config" {
#   description = "Scaling configuration for the node group"
#   type = object({
#     desired_size = number
#     max_size     = number
#     min_size     = number
#   })
# }

# variable "instance_types" {
#   description = "List of instance types associated with the EKS Node Group"
#   type        = list(string)
# }

# variable "map_roles" {
#   description = "Additional IAM roles to add to the aws-auth configmap."
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))
#   default = []
# }

# variable "map_users" {
#   description = "Additional IAM users to add to the aws-auth configmap."
#   type = list(object({
#     userarn  = string
#     username = string
#     groups   = list(string)
#   }))
#   default = []
# }

# variable "admin_roles" {
#   description = "IAM roles with cluster admin access"
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))
#   default = []
# }

# ###########################################################################################

# # ################################################################################
# # Kubernetes Variables
# # ################################################################################

# variable "namespace" {
#   description = "Namespace for the ALB controller service account"
#   type        = string
#   default     = "kube-system"
# }

# variable "service_account_name" {
#   description = "Service account name for the ALB controller"
#   type        = string
#   default     = "aws-load-balancer-controller"
# }

# variable "service_account_labels" {
#   description = "Additional labels to add to the service account"
#   type        = map(string)
#   default     = {}
# }

# # ################################################################################
# # Helm Chart Variables
# # ################################################################################

# variable "helm_chart_version" {
#   description = "Version of the AWS Load Balancer Controller Helm chart"
#   type        = string
#   default     = "1.7.1"
# }

# variable "replica_count" {
#   description = "Number of replicas for the ALB controller"
#   type        = number
#   default     = 2
# }

# # ################################################################################
# # Helm Chart Resource Configuration
# # ################################################################################

# variable "resources_limits_cpu" {
#   description = "CPU limit for controller pods"
#   type        = string
#   default     = "200m"
# }

# variable "resources_limits_memory" {
#   description = "Memory limit for controller pods"
#   type        = string
#   default     = "500Mi"
# }

# variable "resources_requests_cpu" {
#   description = "CPU request for controller pods"
#   type        = string
#   default     = "100m"
# }

# variable "resources_requests_memory" {
#   description = "Memory request for controller pods"
#   type        = string
#   default     = "200Mi"
# }

# # ################################################################################
# # Feature Flags
# # ################################################################################

# variable "enable_shield" {
#   description = "Enable AWS Shield integration"
#   type        = bool
#   default     = false
# }

# variable "enable_waf" {
#   description = "Enable AWS WAF integration"
#   type        = bool
#   default     = false
# }

# variable "enable_wafv2" {
#   description = "Enable AWS WAFv2 integration"
#   type        = bool
#   default     = false
# }

# # ################################################################################
# # Advanced Configuration
# # ################################################################################

# variable "additional_helm_values" {
#   description = "Additional Helm chart values to set"
#   type = list(object({
#     name  = string
#     value = string
#   }))
#   default = []
# }

# variable "helm_wait" {
#   description = "Wait for the Helm deployment to be ready"
#   type        = bool
#   default     = true
# }

# variable "helm_wait_for_jobs" {
#   description = "Wait for Helm jobs to complete"
#   type        = bool
#   default     = false
# }

# variable "helm_timeout" {
#   description = "Timeout for Helm operations (in seconds)"
#   type        = number
#   default     = 600
# }
