################################################################################
# FILE: terraform.tfvars
# PURPOSE: Provide actual values for variables defined in variables.tf
# IMPORTANCE: This file:
#   1. Supplies the specific values for your deployment
#   2. Keeps sensitive data separate from code
#   3. Is automatically loaded by Terraform
#   4. Should be in .gitignore (never commit to version control)
#
# ANALOGY: Think of this as the "answers" to the questions asked in variables.tf
################################################################################

# ===== GCP Configuration =====
# Your Google Cloud Project ID (REQUIRED - must be changed to your project)
project_id = "gcp-terraform-demo-474514"

# Geographic region for your cluster
# Try different regions if you encounter quota limits
region = "us-west1"

# Display name for your Kubernetes cluster in Google Cloud Console
cluster_name = "gke-cluster"

# ===== Node Configuration (optimized for free tier) =====
# Machine type = size of each compute node
# e2-small = smallest free tier eligible machine
machine_type = "e2-small"

# Number of worker nodes to start with
# 1 node is sufficient for learning; increase for production
initial_node_count = 1

# Storage space on each node (in GB)
# 12 GB is suitable for basic testing and learning
disk_size_gb = 12

# ===== Features =====
# Enable Google Cloud Monitoring and Logging (Stackdriver)
# Set to false to avoid costs on free tier
enable_stackdriver = false


