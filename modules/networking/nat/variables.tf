variable "environment" {
  description = "The Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}


variable "public_subnet_ids" {
  description = "List of public subnet IDs for NAT gateway placement"
  type        = list(string)
}