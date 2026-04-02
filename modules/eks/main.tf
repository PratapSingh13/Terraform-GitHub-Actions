/*
──────────────────────────────────────────────────────────────────────
EKS Module – Container Orchestration
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Provision an Amazon EKS Cluster (Control Plane) and a
            Managed Node Group (Worker Nodes).
📅 Created: 14‑01‑2026
👤 Owner:   Yogendra Pratap Singh (yogendra.singh01@nagarro.com)
🏢 Team:    Infrastructure / DevOps
🌍 Region:  ${var.aws_region}
🗂️ Components:
  • aws_eks_cluster "this"
  • aws_eks_node_group "this"
🔗 References:
  – EKS Cluster: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
  – EKS Node Group: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
🔐 Security / Compliance:
  • Control Plane logging enabled recommended for prod (audit, authenticator, etc.).
  • Node Group runs in private subnets (recommended) or public (if specified).
📦 Inputs (variables) – see variables.tf:
  • cluster_name, cluster_version
  • subnet_ids (networking)
  • iam_cluster_role_arn, iam_node_role_arn (permissions)
  • scaling_config (min, max, desired size)
  • instance_types (e.g., ["t3.medium"])
📤 Outputs – see output.tf:
  • cluster_endpoint
  • cluster_name
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# aws_eks_cluster "this"
# ---------------------------------------------------------------------
# The EKS Control Plane.
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-${var.environment}-${var.cluster_name}"
  role_arn = var.iam_cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids             = var.subnet_ids
    endpoint_public_access = true # Allow access from internet (restrict via CIDR in prod)
    security_group_ids     = var.additional_security_group_ids
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project}-${var.environment}-${var.cluster_name}"
      Environment = var.environment
    }
  )
}

# ---------------------------------------------------------------------
# aws_eks_node_group "this"
# ---------------------------------------------------------------------
# Managed Node Group – Worker nodes managed by AWS.
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project}-${var.environment}-node-group"
  node_role_arn   = var.iam_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  instance_types = var.instance_types
  capacity_type  = "ON_DEMAND" # or SPOT

  tags = merge(
    var.tags,
    {
      Name        = "${var.project}-${var.environment}-node-group"
      Environment = var.environment
    }
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # We assume the caller handles explicit `depends_on` or passing valid ARNs implies existence.
}

# ---------------------------------------------------------------------
# OIDC Provider
# ---------------------------------------------------------------------
data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# ---------------------------------------------------------------------
# EKS Access Entries (Permanent fix for aws-auth)
# ---------------------------------------------------------------------

# Access Entry for Node Group Role
resource "aws_eks_access_entry" "node_group" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.iam_node_role_arn
  type          = "EC2_LINUX" # Automatically maps to system:nodes and system:bootstrappers
}

# Admin Roles Access Entries
resource "aws_eks_access_entry" "admins" {
  for_each      = { for r in var.admin_roles : r.rolearn => r }
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.rolearn
  user_name     = each.value.username
}

resource "aws_eks_access_policy_association" "admins" {
  for_each      = { for r in var.admin_roles : r.rolearn => r }
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value.rolearn

  access_scope {
    type = "cluster"
  }
}

# General Roles Access Entries (from map_roles)
resource "aws_eks_access_entry" "roles" {
  for_each      = { for r in var.map_roles : r.rolearn => r }
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.rolearn
  user_name     = each.value.username
}

# User Access Entries (from map_users)
resource "aws_eks_access_entry" "users" {
  for_each      = { for u in var.map_users : u.userarn => u }
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.userarn
  user_name     = each.value.username
}

# Associate Admin Policy to specifically mapped users in system:masters (optional but safer)
resource "aws_eks_access_policy_association" "users_admin" {
  for_each      = { for u in var.map_users : u.userarn => u if contains(u.groups, "system:masters") }
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value.userarn

  access_scope {
    type = "cluster"
  }
}
