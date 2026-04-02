/*
──────────────────────────────────────────────────────────────────────
Helm Chart Submodule for ALB Controller
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Deploy AWS Load Balancer Controller using Helm
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# Helm Release for AWS Load Balancer Controller
# ---------------------------------------------------------------------
resource "helm_release" "this" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = var.chart_name
  namespace  = var.namespace
  version    = var.chart_version

  # Cluster configuration
  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  # Service account configuration
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  # Replica configuration
  set {
    name  = "replicaCount"
    value = var.replica_count
  }

  # Resource limits
  set {
    name  = "resources.limits.cpu"
    value = var.resources_limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources_limits_memory
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources_requests_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources_requests_memory
  }

  # Feature flags
  set {
    name  = "enableShield"
    value = var.enable_shield
  }

  set {
    name  = "enableWaf"
    value = var.enable_waf
  }

  set {
    name  = "enableWafv2"
    value = var.enable_wafv2
  }

  # Additional custom values
  dynamic "set" {
    for_each = var.additional_set_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  # Wait for deployment to be ready
  wait          = var.wait
  wait_for_jobs = var.wait_for_jobs
  timeout       = var.timeout
}
