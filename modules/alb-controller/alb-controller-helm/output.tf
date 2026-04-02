# ################################################################################
# Helm Outputs
# ################################################################################

output "release_name" {
  description = "Name of the Helm release"
  value       = helm_release.this.name
}

output "release_status" {
  description = "Status of the Helm release"
  value       = helm_release.this.status
}

output "chart_version" {
  description = "Version of the deployed Helm chart"
  value       = helm_release.this.version
}

output "namespace" {
  description = "Namespace where the Helm release was deployed"
  value       = helm_release.this.namespace
}
