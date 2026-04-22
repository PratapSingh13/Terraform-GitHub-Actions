# ################################################################################
# Global
# ################################################################################
region      = "ap-south-1"
tagName     = "ng-promotion"
environment = "promotion"
project     = "nagarro"

# ################################################################################
# VPC
# ################################################################################
vpc_cidr = "10.0.0.0/16"


# ################################################################################
# Public and Private Subnets
# ################################################################################

public_subnets_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

# # ################################################################################
# # Security Group
# # ################################################################################
# create_security_group          = true
# security_group_use_name_prefix = false
# security_group_ingress_rules = {
#   http = {
#     ip_protocol = "tcp"
#     from_port   = 80
#     to_port     = 80
#     cidr_ipv4   = "0.0.0.0/0"
#   }
#   https = {
#     ip_protocol = "tcp"
#     from_port   = 443
#     to_port     = 443
#     cidr_ipv4   = "0.0.0.0/0"
#   }
# }

# security_group_egress_rules = {
#   all_outbound = {
#     ip_protocol = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_ipv4   = "0.0.0.0/0"
#   }
# }

# # ################################################################################
# # EKS
# # ################################################################################
cluster_name = "eks-cluster"
# cluster_version = "1.33"

# scaling_config = {
#   desired_size = 1
#   max_size     = 2
#   min_size     = 1
# }

# instance_types = ["t3.small"]

# # admin_role_arn = "..." # Not used, we are using map_users for IAM User

# map_users = [
#   {
#     userarn  = "arn:aws:iam::590379872770:user/yogendra.singh01@nagarro.com"
#     username = "yogendra.singh01"
#     groups   = ["system:masters"]
#   }
# ]
