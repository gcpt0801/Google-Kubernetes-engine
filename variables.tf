################################################################################
# FILE: variables.tf
# PURPOSE: Define input variables that can be customized for this deployment
# IMPORTANCE: Variables allow you to:
#   1. Change deployment settings without editing code
#   2. Reuse the same Terraform code for different environments
#   3. Keep sensitive values in a separate file (terraform.tfvars)
#
# ANALOGY: Think of variables as "parameters" or "configuration options"
#          that you can adjust before running Terraform.
################################################################################

# REQUIRED: GCP Project ID
# This is your unique Google Cloud project identifier
# Must be provided when running Terraform (no default value)
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

# OPTIONAL: GCP region for the Kubernetes cluster
# Region determines geographic location of your resources
# Default: us-central1 (central USA)
variable "region" {
  description = "GCP region for GKE cluster"
  type        = string
  default     = "us-central1"
}

# OPTIONAL: Name of the Kubernetes cluster
# This is the display name in the Google Cloud Console
# Default: gke-cluster
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

# OPTIONAL: Machine type (size) for cluster nodes
# e2-small = small VM size suitable for learning and free tier
# Each node runs containers in your Kubernetes cluster
# Larger machines = higher cost
variable "machine_type" {
  description = "Machine type for GKE nodes (free tier compatible)"
  type        = string
  default     = "e2-small"
}

# OPTIONAL: Number of initial worker nodes
# Each node can run multiple containers
# Minimum: 1 node, increase for higher availability
variable "initial_node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 1
}

# OPTIONAL: Storage disk size for each node (in GB)
# Larger disk = more space for container images and data
# Default: 12 GB (suitable for learning)
variable "disk_size_gb" {
  description = "Disk size in GB for each node"
  type        = number
  default     = 12
}

# OPTIONAL: Enable monitoring and logging
# Stackdriver = Google's monitoring solution
# Disable for free tier to avoid costs
variable "enable_stackdriver" {
  description = "Enable Stackdriver logging and monitoring"
  type        = bool
  default     = false
}

