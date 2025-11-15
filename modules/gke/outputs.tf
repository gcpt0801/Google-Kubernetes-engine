################################################################################
# FILE: modules/gke/outputs.tf
# PURPOSE: Export values from the GKE module back to the caller (main.tf)
# IMPORTANCE: This file:
#   1. Returns important cluster information from this module
#   2. Allows main.tf to access and display cluster details
#   3. Provides data needed to connect to the cluster
#
# ANALOGY: Think of outputs as "return values" from a reusable function/module.
################################################################################

# Return the cluster name to the caller
output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

# Return the Kubernetes API endpoint (the URL to connect to)
# marked 'sensitive' to avoid exposing in logs
output "cluster_host" {
  description = "GKE cluster host"
  value       = "https://${google_container_cluster.primary.endpoint}"
  sensitive   = true  # Hide from console output for security
}

# Return the cluster's CA certificate for authentication
# Needed to securely connect to the Kubernetes API
# marked 'sensitive' because it's a security credential
output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true  # Hide from console output for security
}

# Return the region where the cluster was created
output "region" {
  description = "GCP region"
  value       = var.region
}

# Return the GCP project ID for reference
output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

################################################################################
# SECURITY NOTE:
# Outputs marked 'sensitive = true' are hidden from:
# - Normal 'terraform output' command
# - Terraform logs
# - Standard terminal output
#
# To view sensitive outputs, use:
#   terraform output -json
#
# This protects credentials and sensitive data from accidental exposure.
################################################################################
