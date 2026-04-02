variable "vpc_id" {
  description = "Provide VPC ID"
  type        = string
}

variable "environment" {
  description = "The Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for tagging"
  type        = string
}

variable "availability_zones" {
  description = "The az where resources will be deployed"
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "CIDR block for Public Subnet"
  type        = list(string)
}
