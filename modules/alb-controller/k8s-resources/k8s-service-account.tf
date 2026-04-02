/*
──────────────────────────────────────────────────────────────────────
Kubernetes Resources Submodule for ALB Controller
──────────────────────────────────────────────────────────────────────
📌 Purpose:  Create Kubernetes service account for ALB Controller
──────────────────────────────────────────────────────────────────────
*/

# ---------------------------------------------------------------------
# Kubernetes Service Account
# ---------------------------------------------------------------------
resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = var.iam_role_arn
    }

    labels = merge(
      var.labels,
      {
        "app.kubernetes.io/name"       = "aws-load-balancer-controller"
        "app.kubernetes.io/component"  = "controller"
        "app.kubernetes.io/managed-by" = "terraform"
      }
    )
  }
}
