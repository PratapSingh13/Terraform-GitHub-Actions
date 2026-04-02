# ---------------------------------------------------------------------
# Input Variables for IAM Module
# ---------------------------------------------------------------------

variable "project" {
  description = "Project name – used for naming and tagging resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "A map of additional tags to add to all resources"
  type        = map(string)
  default     = {}
}
