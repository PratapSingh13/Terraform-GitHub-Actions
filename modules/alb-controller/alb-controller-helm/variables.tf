# ################################################################################
# Helm Chart Variables
# ################################################################################

variable "release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://aws.github.io/eks-charts"
}

variable "chart_name" {
  description = "Name of the Helm chart"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "1.7.1"
}

variable "namespace" {
  description = "Kubernetes namespace for the Helm release"
  type        = string
  default     = "kube-system"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region where the cluster is deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  type        = string
}

variable "service_account_name" {
  description = "Name of the Kubernetes service account to use"
  type        = string
}

variable "replica_count" {
  description = "Number of controller replicas"
  type        = number
  default     = 2
}

variable "resources_limits_cpu" {
  description = "CPU limit for controller pods"
  type        = string
  default     = "200m"
}

variable "resources_limits_memory" {
  description = "Memory limit for controller pods"
  type        = string
  default     = "500Mi"
}

variable "resources_requests_cpu" {
  description = "CPU request for controller pods"
  type        = string
  default     = "100m"
}

variable "resources_requests_memory" {
  description = "Memory request for controller pods"
  type        = string
  default     = "200Mi"
}

variable "enable_shield" {
  description = "Enable AWS Shield integration"
  type        = bool
  default     = false
}

variable "enable_waf" {
  description = "Enable AWS WAF integration"
  type        = bool
  default     = false
}

variable "enable_wafv2" {
  description = "Enable AWS WAFv2 integration"
  type        = bool
  default     = false
}

variable "additional_set_values" {
  description = "Additional Helm chart values to set"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "wait" {
  description = "Wait for the deployment to be ready"
  type        = bool
  default     = true
}

variable "wait_for_jobs" {
  description = "Wait for jobs to complete"
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Timeout for Helm operations (in seconds)"
  type        = number
  default     = 600
}
