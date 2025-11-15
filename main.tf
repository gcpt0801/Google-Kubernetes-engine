################################################################################
# FILE: main.tf
# PURPOSE: Root configuration that orchestrates the entire deployment
# IMPORTANCE: This file:
#   1. Calls the GKE module to create a Kubernetes cluster
#   2. Passes variables to the module
#   3. Serves as the main entry point for Terraform
#
# ANALOGY: Think of this as the "conductor" that directs other parts
#          of your infrastructure code.
################################################################################

# Call the GKE module to create a Google Kubernetes Engine cluster
# Modules are reusable packages of Terraform code
module "gke_cluster" {
  # Location of the module (relative path to the gke module folder)
  source = "./modules/gke"

  # Pass all variables from root to the module
  # These values come from terraform.tfvars or command-line overrides
  project_id         = var.project_id         # GCP project ID
  region             = var.region             # Region for cluster
  cluster_name       = var.cluster_name       # Name of the cluster
  machine_type       = var.machine_type       # Size of compute instances
  initial_node_count = var.initial_node_count # Number of initial nodes
  disk_size_gb       = var.disk_size_gb       # Storage per node
  enable_stackdriver = var.enable_stackdriver # Monitoring enabled?
}
