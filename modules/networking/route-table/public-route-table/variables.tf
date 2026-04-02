#Variables for Public Route Table
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

variable "igw_id" {
  description = "Internet Gateway ID for the VPC"
  type        = string
  default     = ""
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}
