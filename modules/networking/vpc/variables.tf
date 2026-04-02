variable "environment" {
  description = "The Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  type        = string
}
