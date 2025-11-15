################################################################################
# FILE: modules/gke/main.tf
# PURPOSE: Define the actual Google Kubernetes Engine cluster resource
# IMPORTANCE: This file:
#   1. Creates the actual GKE cluster in Google Cloud
#   2. Configures cluster settings and features
#   3. Defines the node pool (worker machines)
#   4. Enables/disables various Kubernetes features
#
# ANALOGY: Think of this as the "recipe" that creates your Kubernetes cluster.
################################################################################

# Create a Google Kubernetes Engine cluster
resource "google_container_cluster" "primary" {
  # Basic cluster information
  name     = var.cluster_name  # Display name in Google Cloud Console
  location = "${var.region}-a" # Zone (region + letter a,b,c)
  project  = var.project_id    # Which GCP project to create in
  # Allow Terraform to delete the cluster: ensure deletion protection is off
  deletion_protection = false

  # Initial setup: how many worker nodes to create at startup
  initial_node_count = var.initial_node_count

  # Keep the default node pool (true = keep it, false = delete after creation)
  remove_default_node_pool = false

  # ===== Kubernetes Add-ons (optional features) =====
  addons_config {
    # HTTP(S) Load Balancing: distribute traffic across pods
    http_load_balancing {
      disabled = false  # Keep enabled
    }

    # Horizontal Pod Autoscaler: automatically scale pods based on demand
    horizontal_pod_autoscaling {
      disabled = false  # Keep enabled
    }

    # Network Policy: control traffic between pods
    # Disabled by default to reduce complexity for beginners
    network_policy_config {
      disabled = true
    }
  }

  # ===== Logging and Monitoring =====
  # Conditional: use Stackdriver if enabled, otherwise disable
  logging_service = var.enable_stackdriver ? "logging.googleapis.com/kubernetes" : "none"
  monitoring_service = var.enable_stackdriver ? "monitoring.googleapis.com/kubernetes" : "none"

  # ===== Release Channel =====
  # REGULAR = stable Kubernetes versions with quarterly updates
  release_channel {
    channel = "REGULAR"
  }

  # ===== Maintenance Policy =====
  # When can Google perform cluster maintenance?
  # 03:00 UTC = 3 AM UTC (adjust as needed for your timezone)
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # ===== Node Configuration =====
  # Settings for the worker machines (compute nodes)
  node_config {
    # Preemptible VMs: cheaper machines Google can reclaim with 24h notice
    # Good for learning/testing, not production
    preemptible = true

    # Size of each compute machine
    machine_type = var.machine_type

    # Storage space per node
    disk_size_gb = var.disk_size_gb

    # Type of disk: pd-standard = standard persistent disk (affordable)
    disk_type = "pd-standard"

    # OAuth scopes: permissions the nodes have in Google Cloud
    # cloud-platform = broad access to Google Cloud services
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Labels: metadata to help organize and identify nodes
    labels = {
      env = "prod"  # Mark as production environment
    }

    # Network tags: used for firewall rules
    tags = ["gke-node", var.cluster_name]

    # ===== Security Configuration =====
    shielded_instance_config {
      # Secure Boot: verify machine hasn't been tampered with at startup
      enable_secure_boot = false  # Disabled for compatibility

      # Integrity Monitoring: detect changes to system files
      enable_integrity_monitoring = true  # Enabled for security
    }
  }
}

