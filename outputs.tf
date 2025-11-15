################################################################################
# FILE: outputs.tf
# PURPOSE: Define what information Terraform displays after deployment
# IMPORTANCE: Outputs:
#   1. Display important values after running 'terraform apply'
#   2. Allow other tools to use these values (CI/CD pipelines, etc.)
#   3. Provide connection details for accessing your cluster
#
# ANALOGY: Think of outputs as "return values" from a function.
#          They let you see the results of what Terraform created.
################################################################################

# Display the name of the created Kubernetes cluster
output "kubernetes_cluster_name" {
  description = "GKE Cluster Name"
  value       = module.gke_cluster.cluster_name
}

# Display the Kubernetes API endpoint (URL to connect to the cluster)
# marked 'sensitive' so it won't be printed in logs by default
output "kubernetes_cluster_host" {
  description = "GKE Cluster Host"
  value       = module.gke_cluster.cluster_host
  sensitive   = true # Hide from terminal output for security
}

# Display the GCP region where the cluster was created
output "region" {
  description = "GCP region"
  value       = var.region
}

# Display the GCP project ID for reference
output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

################################################################################
# USAGE: After running 'terraform apply', run these commands to see outputs:
# - terraform output                  (show all outputs)
# - terraform output kubernetes_cluster_name  (show specific output)
#
# SECURITY NOTE: Outputs marked 'sensitive' are hidden from normal view.
#                Use 'terraform output -json' to see all values.
################################################################################
