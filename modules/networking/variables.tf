# ################################################################################
# Variables for VPC
# ################################################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment for the VPC (e.g., dev, staging, prod)"
  type        = string
  default     = "promotion"
}

variable "project" {
  description = "Project name for the VPC"
  type        = string
  default     = "nagarro"
}

# ################################################################################
# Variables for Subnets
# ################################################################################

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the public subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

# ################################################################################
# Security Group
# ################################################################################
variable "create_security_group" {
  description = "Determines if a security group is created"
  type        = bool
}

variable "security_group_use_name_prefix" {
  description = "Determines whether the security group name (`security_group_name`) is used as a prefix"
  type        = bool
}

variable "security_group_tags" {
  description = "A map of additional tags to add to the security group created"
  type        = map(string)
  default     = {}
}

variable "security_group_egress_rules" {
  description = "Security group egress rules to add to the security group created"
  type = map(object({
    ip_protocol = optional(string) # protocol like tcp, udp, -1 (all)
    from_port   = optional(number) # starting port
    to_port     = optional(number) # ending port
    cidr_ipv4   = optional(string) # destination CIDR
  }))
  default = {}
}

variable "security_group_ingress_rules" {
  description = "Security group ingress rules to add to the security group created"
  type = map(object({
    ip_protocol = optional(string)
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# ################################################################################
# # Local Variables
# ################################################################################
variable "create" {
  type        = bool
  default     = true
  description = "Controls if resources should be created (affects nearly all resources)"
}
