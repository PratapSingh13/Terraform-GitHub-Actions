# ################################################################################
# Kubernetes Outputs
# ################################################################################

output "service_account_name" {
  description = "Name of the Kubernetes service account"
  value       = kubernetes_service_account.this.metadata[0].name
}

output "namespace" {
  description = "Namespace where the service account was created"
  value       = kubernetes_service_account.this.metadata[0].namespace
}
