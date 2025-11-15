################################################################################
# FILE: providers.tf
# PURPOSE: Configure Terraform to work with Google Cloud Platform (GCP)
# IMPORTANCE: This file tells Terraform:
#   1. Which cloud provider to use (Google Cloud)
#   2. Which version of the Google provider to install
#   3. How to authenticate with GCP using credentials
#   4. Which GCP project and region to deploy resources to
#
# ANALOGY: Think of this as the "login configuration" for Terraform to
#          communicate with Google Cloud.
################################################################################

terraform {
  # Specify which providers (cloud platforms) this configuration requires
  # Providers are plugins that let Terraform talk to specific services
  required_providers {
    google = {
      source  = "hashicorp/google"  # Official Google Cloud provider
      version = "6.50.0"             # Specific version to ensure consistency
    }
  }
}

# Configure the Google Cloud provider with authentication details
provider "google" {
  project     = var.project_id  # GCP project where resources will be created
  region      = var.region      # Default region for GCP resources
}
