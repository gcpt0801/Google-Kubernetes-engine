################################################################################
# FILE: modules/gke/variables.tf
# PURPOSE: Define input parameters for the GKE module
# IMPORTANCE: This file:
#   1. Specifies what configuration options the GKE module accepts
#   2. Allows main.tf to pass values to this module
#   3. Makes the module reusable and flexible
#
# ANALOGY: Think of these as "function parameters" that the GKE module accepts.
################################################################################

# REQUIRED: GCP Project ID
# No default value means this must always be provided by the caller
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

# REQUIRED: GCP Region
# No default value means this must always be provided by the caller
variable "region" {
  description = "GCP region"
  type        = string
}

# REQUIRED: Kubernetes Cluster Name
# No default value means this must always be provided by the caller
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

# OPTIONAL: Machine type (size of compute nodes)
# Has default value, so caller can omit if they like the default
variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-small"  # Free tier eligible
}

# OPTIONAL: Number of initial worker nodes
# Kubernetes will distribute containers across these nodes
variable "initial_node_count" {
  description = "Initial number of nodes"
  type        = number
  default     = 1
}

# OPTIONAL: Storage disk size (in GB)
# Each node gets this much disk space for container images and data
variable "disk_size_gb" {
  description = "Disk size in GB for each node"
  type        = number
  default     = 12
}

# OPTIONAL: Enable monitoring and logging
# Stackdriver = Google's centralized logging and monitoring service
variable "enable_stackdriver" {
  description = "Enable Stackdriver logging and monitoring"
  type        = bool
  default     = false
}

