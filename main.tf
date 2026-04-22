locals {
  availability_zones = ["${var.region}a", "${var.region}b"]
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
    env = {
      AWS_DEFAULT_OUTPUT = "json"
    }
  }
}

module "vpc" {
  source = "./modules/networking/vpc"

  vpc_cidr    = var.vpc_cidr
  environment = var.environment
  project     = var.project
}

module "public_subnet" {
  source = "./modules/networking/subnet/public-subnet"

  vpc_id              = module.vpc.vpc_id
  public_subnets_cidr = var.public_subnets_cidr
  availability_zones  = var.availability_zones
  environment         = var.environment
  project             = var.project
  cluster_name        = var.cluster_name

  depends_on = [module.vpc]
}

module "public_route_table" {
  source = "./modules/networking/route-table/public-route-table"

  vpc_id      = module.vpc.vpc_id
  igw_id      = module.igw.igw_id
  environment = var.environment
  project     = var.project
  # Pass the public subnets CIDR blocks to the route table association
  public_subnets_cidr = module.public_subnet.public_subnet_ids

  depends_on = [module.public_subnet, module.igw]
}

# module "igw" {
#   source = "./modules/networking/igw"

#   vpc_id      = module.vpc.vpc_id
#   environment = var.environment
#   project     = var.project

#   depends_on = [module.vpc]
# }

module "private_subnet" {
  source = "./modules/networking/subnet/private-subnet"

  vpc_id               = module.vpc.vpc_id
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
  environment          = var.environment
  project              = var.project
  cluster_name         = var.cluster_name

  depends_on = [module.vpc]
}

# module "private_route_table" {
#   source = "./modules/networking/route-table/private-route-table"

#   vpc_id      = module.vpc.vpc_id
#   nat_id      = module.nat.nat_gateway_id
#   environment = var.environment
#   project     = var.project
#   # Pass the private subnets CIDR blocks to the route table association
#   private_subnets_cidr = module.private_subnet.private_subnet_ids

#   depends_on = [module.private_subnet, module.nat]
# }

# module "nat" {
#   source = "./modules/networking/nat"

#   environment       = var.environment
#   project           = var.project
#   public_subnet_ids = module.public_subnet.public_subnet_ids

#   depends_on = [module.public_subnet]
# }

# module "security_group" {
#   source = "./modules/networking/security-group"

#   create_security_group          = var.create_security_group
#   environment                    = var.environment
#   vpc_id                         = module.vpc.vpc_id
#   security_group_name            = "${var.project}-${var.environment}-default-sg"
#   security_group_use_name_prefix = var.security_group_use_name_prefix
#   security_group_description     = "This security group belongs to general applications in the ${var.environment}-${var.project} environment"
#   security_group_tags            = var.security_group_tags
#   security_group_ingress_rules   = var.security_group_ingress_rules
#   security_group_egress_rules    = var.security_group_egress_rules

#   tags = merge(var.tags, { terraform-aws-modules = "sg" })

#   depends_on = [module.vpc]
# }

# module "iam" {
#   source = "./modules/iam"

#   project     = var.project
#   environment = var.environment
#   tags        = var.tags
# }

# resource "terraform_data" "eni_cleanup" {
#   input = {
#     vpc_id       = module.vpc.vpc_id
#     region       = var.region
#     cluster_name = "${var.project}-${var.environment}-${var.cluster_name}"
#   }

#   provisioner "local-exec" {
#     when    = destroy
#     command = "bash scripts/cleanup-enis.sh ${self.input.vpc_id} ${self.input.region} ${self.input.cluster_name}"
#   }

#   depends_on = [module.public_subnet]
# }

# module "eks" {
#   source = "./modules/eks"

#   project                       = var.project
#   environment                   = var.environment
#   cluster_name                  = var.cluster_name
#   cluster_version               = var.cluster_version
#   subnet_ids                    = module.private_subnet.private_subnet_ids
#   iam_cluster_role_arn          = module.iam.eks_cluster_role_arn
#   iam_node_role_arn             = module.iam.eks_node_group_role_arn
#   scaling_config                = var.scaling_config
#   instance_types                = var.instance_types
#   additional_security_group_ids = [module.security_group.security_group_id]
#   admin_roles                   = var.admin_roles
#   map_roles                     = var.map_roles
#   map_users                     = var.map_users
#   tags                          = var.tags

#   depends_on = [module.iam, module.private_subnet, module.nat, terraform_data.eni_cleanup]
# }

# module "eks_addons" {
#   source           = "./modules/eks-addons"
#   cluster_name     = module.eks.cluster_name
#   tags             = var.tags
#   ebs_csi_role_arn = module.eks.ebs_csi_role_arn

#   depends_on = [module.eks]
# }

# # module "alb_controller" {
# #   source               = "./modules/alb-controller"
# #   project              = var.project
# #   environment          = var.environment
# #   tags                 = var.tags
# #   oidc_provider_arn    = module.eks.oidc_provider_arn
# #   oidc_issuer_url      = module.eks.oidc_issuer_url
# #   namespace            = "kube-system" # or your preferred namespace
# #   service_account_name = "aws-load-balancer-controller"
# #   cluster_name         = module.eks.cluster_name
# #   region               = var.region
# #   vpc_id               = module.vpc.vpc_id

# #   depends_on = [module.eks, terraform_data.update_kubeconfig, aws_eks_access_entry.admin_user, aws_eks_access_policy_association.admin_policy]
# # }

# resource "terraform_data" "update_kubeconfig" {
#   triggers_replace = [module.eks.cluster_name]

#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
#   }

#   depends_on = [module.eks]
# }


# resource "aws_eks_access_entry" "admin_user" {
#   cluster_name  = module.eks.cluster_name
#   principal_arn = "arn:aws:iam::590379872770:user/yogendra.singh"
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "admin_policy" {
#   cluster_name  = module.eks.cluster_name
#   principal_arn = aws_eks_access_entry.admin_user.principal_arn

#   policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

#   access_scope {
#     type = "cluster"
#   }
# }


# /*
# ──────────────────────────────────────────────────────────────────────
# ALB Ingress Controller Module – Orchestrator
# ──────────────────────────────────────────────────────────────────────
# 📌 Purpose:  Deploy AWS Load Balancer Controller on EKS using modular
#             architecture with separate IAM, K8s, and Helm submodules
# 📅 Created: 17‑02‑2026
# 👤 Owner:   Yogendra Pratap Singh (yogendra.singh01@nagarro.com)
# 🏢 Team:    Infrastructure / DevOps
# 🗂️ Architecture:
#   • IAM Module: Creates IRSA role and policies
#   • K8s Resources Module: Creates service account
#   • Helm Chart Module: Deploys controller via Helm
# 🔗 References:
#   – AWS LB Controller: https://kubernetes-sigs.github.io/aws-load-balancer-controller/
#   – Helm Chart: https://github.com/aws/eks-charts
# ──────────────────────────────────────────────────────────────────────
# */

# # ---------------------------------------------------------------------
# # IAM Module - Creates IAM role and policy for IRSA
# # ---------------------------------------------------------------------
# module "alb-controller-iam" {
#   source = "./modules/alb-controller/controller-iam"

#   project              = var.project
#   environment          = var.environment
#   oidc_provider_arn    = module.eks.oidc_provider_arn
#   oidc_issuer_url      = module.eks.oidc_issuer_url
#   namespace            = var.namespace
#   service_account_name = var.service_account_name
#   policy_json_path     = "${path.module}/scripts/alb-controller-iam-policy.json"
#   tags                 = var.tags

#   depends_on = [module.eks, terraform_data.update_kubeconfig, aws_eks_access_entry.admin_user, aws_eks_access_policy_association.admin_policy]
# }

# # ---------------------------------------------------------------------
# # Kubernetes Resources Module - Creates service account
# # ---------------------------------------------------------------------
# module "k8s_resources" {
#   source = "./modules/alb-controller/k8s-resources"

#   namespace            = var.namespace
#   service_account_name = var.service_account_name
#   iam_role_arn         = module.alb-controller-iam.role_arn
#   labels               = var.service_account_labels

#   depends_on = [module.alb-controller-iam]
# }

# # ---------------------------------------------------------------------
# # Helm Chart Module - Deploys AWS Load Balancer Controller
# # ---------------------------------------------------------------------
# module "helm_chart" {
#   source = "./modules/alb-controller/alb-controller-helm"

#   cluster_name         = module.eks.cluster_name
#   region               = var.region
#   vpc_id               = module.vpc.vpc_id
#   namespace            = var.namespace
#   service_account_name = module.k8s_resources.service_account_name
#   chart_version        = var.helm_chart_version
#   replica_count        = var.replica_count

#   # Resource configuration
#   resources_limits_cpu      = var.resources_limits_cpu
#   resources_limits_memory   = var.resources_limits_memory
#   resources_requests_cpu    = var.resources_requests_cpu
#   resources_requests_memory = var.resources_requests_memory

#   # Feature flags
#   enable_shield = var.enable_shield
#   enable_waf    = var.enable_waf
#   enable_wafv2  = var.enable_wafv2

#   # Additional custom values
#   additional_set_values = var.additional_helm_values

#   # Helm operation settings
#   wait          = var.helm_wait
#   wait_for_jobs = var.helm_wait_for_jobs
#   timeout       = var.helm_timeout

#   depends_on = [module.k8s_resources]
# }
