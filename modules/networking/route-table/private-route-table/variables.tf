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

variable "nat_id" {
  description = "NAT Gateway ID for the Route Table"
  type        = string
  default     = ""
}

variable "private_subnets_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}
