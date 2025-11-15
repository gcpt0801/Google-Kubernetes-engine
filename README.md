# GKE Terraform Project

A beginner-friendly Terraform configuration for deploying a Google Kubernetes Engine (GKE) cluster on Google Cloud Platform (GCP).

---

## 📋 Project Overview

This project demonstrates Infrastructure as Code (IaC) best practices by using Terraform to automate the deployment of a production-ready GKE cluster. The configuration is modular, reusable, and optimized for the free tier.

**Key Features:**
- ✅ Automated GKE cluster creation
- ✅ Configurable node pools with preemptible VMs (cost-effective)
- ✅ Horizontal Pod Autoscaling enabled
- ✅ Load balancing configured
- ✅ Optional Stackdriver monitoring and logging
- ✅ Security best practices (Integrity Monitoring enabled)

---

## 📁 Project Structure

```
terraform/
├── README.md                          # This file - project documentation
├── main.tf                            # Root configuration (orchestrator)
├── providers.tf                       # GCP provider configuration & authentication
├── variables.tf                       # Input variables (root level)
├── outputs.tf                         # Output values displayed after deployment
├── terraform.tfvars                   # Variable values (your configuration)
├── terraform.tfstate                  # Terraform state file (auto-managed)
├── terraform.tfstate.backup           # Backup of previous state
├── gcp-terraform-demo-*.json          # GCP service account credentials (KEEP SECRET!)
├── plan.txt                           # Human-readable Terraform plan
├── tfplan                             # Binary Terraform plan file
├── tfplan.json                        # JSON format Terraform plan
├── tfplan.jsonls                      # JSONL format Terraform plan
│
└── modules/
    └── gke/                           # Reusable GKE module
        ├── main.tf                    # GKE cluster resource definition
        ├── variables.tf               # Module input variables
        └── outputs.tf                 # Module output values
```

---

## 🔄 How the Configuration Works

### File Relationships

```
terraform.tfvars
       ↓
   (provides values to)
       ↓
   variables.tf (root)
       ↓
   main.tf (calls module)
       ↓
   modules/gke/
   ├── variables.tf (receives values)
   ├── main.tf (creates resources)
   └── outputs.tf (returns values)
       ↓
   outputs.tf (root - displays results)
```

### Execution Flow

1. **`providers.tf`** - Establishes connection to Google Cloud
   - Specifies Google provider version
   - Authenticates using service account credentials
   - Sets default project and region

2. **`variables.tf`** (root) - Defines input parameters
   - `project_id` (REQUIRED) - Your GCP project ID
   - `region` (optional, default: us-central1) - Geographic region
   - `cluster_name` (optional) - Kubernetes cluster name
   - `machine_type` (optional) - Compute instance size
   - `initial_node_count` (optional) - Number of worker nodes
   - `disk_size_gb` (optional) - Storage per node
   - `enable_stackdriver` (optional) - Monitoring & logging

3. **`terraform.tfvars`** - Supplies actual values
   - Read automatically by Terraform
   - Contains your specific configuration
   - Should be kept out of version control (.gitignore)

4. **`main.tf`** (root) - Orchestrates the deployment
   - Calls the GKE module
   - Passes variables to the module
   - Acts as the entry point

5. **`modules/gke/main.tf`** - Creates the actual cluster
   - Defines Google Container Cluster resource
   - Configures cluster settings (addons, logging, monitoring)
   - Defines node pool configuration
   - Applies security settings

6. **`outputs.tf`** (root + module) - Displays results
   - Module outputs return cluster information
   - Root outputs display final results
   - Marked as sensitive to protect credentials

---

## 📝 File Descriptions

### Root Level Files

#### `providers.tf`
**Purpose:** Configure Terraform to work with Google Cloud

**What it does:**
- Specifies the Google provider and its version
- Authenticates with GCP using a service account JSON file
- Sets the default GCP project and region

**Key Configuration:**
```hcl
provider "google" {
  project     = var.project_id     # Your GCP project
  region      = var.region         # Default region
  credentials = file("...")        # Authentication file
}
```

#### `variables.tf`
**Purpose:** Define input parameters for the root configuration

**What it does:**
- Declares variables that can be customized
- Specifies required vs. optional values
- Provides default values where appropriate

**Variable Types:**
- `project_id` - REQUIRED (no default)
- All others - OPTIONAL (have defaults)

#### `main.tf`
**Purpose:** Root orchestration configuration

**What it does:**
- Calls the GKE module from `modules/gke/`
- Passes all variables to the module
- Serves as the entry point for Terraform

**Analogy:** Think of this as a conductor directing the orchestra.

#### `outputs.tf`
**Purpose:** Display important values after deployment

**What it displays:**
- `kubernetes_cluster_name` - The cluster name
- `kubernetes_cluster_host` - The API endpoint (sensitive)
- `region` - Deployment region
- `project_id` - Your GCP project

**Usage:**
```bash
terraform output                          # Show all outputs
terraform output kubernetes_cluster_name  # Show specific output
terraform output -json                    # Show sensitive values
```

#### `terraform.tfvars`
**Purpose:** Provide actual values for variables

**What it contains:**
- GCP Project ID
- Cluster name and region
- Node configuration (machine type, disk size, count)
- Feature flags (monitoring/logging)

**⚠️ Security:** Never commit this file to version control! Use `.gitignore`

---

### Module Files (`modules/gke/`)

#### `modules/gke/variables.tf`
**Purpose:** Define input parameters for the GKE module

**What it does:**
- Declares what configuration the module accepts
- Specifies which values are required vs. optional
- Acts as the module's "function signature"

**Analogy:** Like parameters in a function definition.

#### `modules/gke/main.tf`
**Purpose:** Define the actual GKE cluster resource

**What it creates:**
- `google_container_cluster` - The Kubernetes cluster itself
- Configures all cluster features and settings

**Key Configuration Sections:**

1. **Basic Setup**
   - Cluster name, location (region + zone)
   - Initial node count
   - Project ID

2. **Kubernetes Add-ons**
   - HTTP Load Balancing (distribute traffic)
   - Horizontal Pod Autoscaling (auto-scale based on demand)
   - Network Policy (optional, disabled by default)

3. **Logging & Monitoring**
   - Conditional Stackdriver configuration
   - Based on `enable_stackdriver` variable

4. **Release Channel**
   - Set to "REGULAR" for stable, quarterly updates
   - Automatic cluster upgrades handled by Google

5. **Maintenance Policy**
   - Daily maintenance window at 03:00 UTC
   - Google performs automatic maintenance during this window

6. **Node Configuration**
   - Machine type (e.g., e2-small)
   - Disk type and size
   - OAuth scopes (permissions for the nodes)
   - Labels (metadata for organization)
   - Network tags (used for firewall rules)

7. **Security**
   - Integrity Monitoring enabled
   - Secure Boot disabled (for compatibility)

#### `modules/gke/outputs.tf`
**Purpose:** Export values from the module

**What it returns:**
- `cluster_name` - Name of the created cluster
- `cluster_host` - Kubernetes API endpoint (sensitive)
- `cluster_ca_certificate` - CA cert for authentication (sensitive)
- `region` - Deployment region
- `project_id` - GCP project ID

**Analogy:** Like return values from a function.

---

## 🚀 Getting Started

### Prerequisites
- Terraform installed (v1.0+)
- Google Cloud Platform account
- GCP project created
- Service account with appropriate permissions
- Service account JSON credentials file

### Initial Setup

1. **Update `terraform.tfvars`**
   ```hcl
   project_id = "your-actual-gcp-project-id"
   region     = "your-desired-region"
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```
   This downloads the Google provider and initializes the state file.

3. **Validate Configuration**
   ```bash
   terraform validate
   ```
   Checks syntax and configuration validity.

4. **Plan the Deployment**
   ```bash
   terraform plan -out=tfplan
   ```
   Shows what resources will be created without actually creating them.

5. **Apply the Configuration**
   ```bash
   terraform apply tfplan
   ```
   Creates the GKE cluster and other resources.

### Deployment Options

**Minimal Setup (Free Tier Optimized)**
```hcl
project_id         = "your-project"
region             = "us-central1"
cluster_name       = "gke-cluster"
machine_type       = "e2-small"
initial_node_count = 1
disk_size_gb       = 12
enable_stackdriver = false
```

**Production Setup**
```hcl
project_id         = "your-project"
region             = "us-central1"
cluster_name       = "gke-production"
machine_type       = "n1-standard-2"
initial_node_count = 3
disk_size_gb       = 50
enable_stackdriver = true
```

---

## 🔧 Common Tasks

### View Cluster Information
```bash
# After successful deployment:
terraform output

# View sensitive outputs (API endpoint, certificates):
terraform output -json

# Get just the cluster name:
terraform output kubernetes_cluster_name

# Get cluster API endpoint:
terraform output kubernetes_cluster_host
```

### Update Configuration
```bash
# Modify terraform.tfvars
# Then plan changes:
terraform plan

# Apply changes:
terraform apply
```

### Scale Cluster
```bash
# Update initial_node_count in terraform.tfvars
# For example: initial_node_count = 3
# Then:
terraform apply
```

### Destroy Resources
```bash
# Remove all resources (WARNING: this deletes the cluster!)
terraform destroy
```

---

## 📊 Variable Reference

| Variable | Type | Default | Required | Description |
|----------|------|---------|----------|-------------|
| `project_id` | string | - | ✅ Yes | GCP Project ID |
| `region` | string | us-central1 | ❌ No | GCP region for cluster |
| `cluster_name` | string | gke-cluster | ❌ No | Kubernetes cluster name |
| `machine_type` | string | e2-small | ❌ No | Compute node size |
| `initial_node_count` | number | 1 | ❌ No | Initial worker nodes |
| `disk_size_gb` | number | 12 | ❌ No | Storage per node (GB) |
| `enable_stackdriver` | bool | false | ❌ No | Enable monitoring/logging |

---

## 📤 Output Reference

| Output | Sensitivity | Description |
|--------|-------------|-------------|
| `kubernetes_cluster_name` | Public | Cluster name |
| `kubernetes_cluster_host` | 🔒 Sensitive | API endpoint URL |
| `region` | Public | Deployment region |
| `project_id` | Public | GCP project ID |

---

## 🛡️ Security Best Practices

### Credentials
- ✅ Use service account with minimal required permissions
- ❌ Never commit `terraform.tfvars` to git
- ❌ Never commit `.json` credentials file to git
- ✅ Use `.gitignore` to exclude sensitive files

### Terraform State
- ✅ State file contains sensitive information
- ❌ Never commit `terraform.tfstate` to git
- ✅ Consider remote state (Google Cloud Storage, Terraform Cloud)
- ✅ Enable encryption for remote state

### Example `.gitignore`
```
# Terraform files
terraform.tfvars
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Credentials
*.json
gcp-*.json

# Plan files
tfplan
tfplan.json
tfplan.jsonls
plan.txt
```

### Cluster Security
- ✅ Integrity Monitoring enabled
- ✅ Preemptible VMs for cost (but not for production)
- ✅ OAuth scopes limited to cloud-platform
- ✅ Network tags for firewall control
- ✅ Regular maintenance window configured

---

## 🐛 Troubleshooting

### Error: "Project ID not provided"
**Solution:** Ensure `project_id` is set in `terraform.tfvars`

### Error: "Error reading credentials"
**Solution:** Verify the credentials JSON file path in `providers.tf` is correct

### Error: "Quota exceeded"
**Solution:** Try a different region or machine type in `terraform.tfvars`

### Error: "Authentication required"
**Solution:** Ensure service account has Editor or Kubernetes Engine Admin role

### Cluster creation takes too long
**Normal:** GKE cluster creation typically takes 5-10 minutes

---

## 📚 Module Modularity

This project uses a modular structure with the `gke` module. This design allows:

1. **Reusability** - Use the same module in different projects
2. **Maintainability** - Update cluster logic in one place
3. **Scalability** - Create multiple clusters by calling the module multiple times
4. **Testability** - Test module independently

### Example: Creating Multiple Clusters

```hcl
# In main.tf, add:
module "gke_cluster_prod" {
  source = "./modules/gke"
  project_id   = var.project_id
  region       = "us-central1"
  cluster_name = "gke-production"
  # ... other variables
}

module "gke_cluster_dev" {
  source = "./modules/gke"
  project_id   = var.project_id
  region       = "us-west1"
  cluster_name = "gke-development"
  # ... other variables
}
```

---

## 🔄 Terraform Workflow

```
┌─────────────────────────────────────┐
│   terraform init                    │
│   (Initialize working directory)    │
└────────────────┬────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│   terraform validate                │
│   (Check configuration syntax)      │
└────────────────┬────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│   terraform plan                    │
│   (Preview changes)                 │
└────────────────┬────────────────────┘
                 ↓
         Review the plan
                 ↓
┌─────────────────────────────────────┐
│   terraform apply                   │
│   (Create resources)                │
└────────────────┬────────────────────┘
                 ↓
      Cluster is ready to use!
```

---

## 📖 Useful Terraform Commands

```bash
# Initialize Terraform working directory
terraform init

# Validate configuration files
terraform validate

# Format code according to standard
terraform fmt

# Show resources managed by Terraform
terraform state list

# Show detailed state of a resource
terraform state show module.gke_cluster.google_container_cluster.primary

# Output all outputs
terraform output

# Destroy specific resource (careful!)
terraform destroy -target=module.gke_cluster.google_container_cluster.primary

# Get help on a command
terraform help
```

---

## 🎯 Next Steps

After successfully deploying the cluster:

1. **Connect to Cluster**
   ```bash
   gcloud container clusters get-credentials gke-cluster --region us-central1
   ```

2. **Verify Cluster**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

3. **Deploy Applications**
   ```bash
   kubectl apply -f app-deployment.yaml
   ```

4. **Monitor Cluster**
   - Google Cloud Console: kubernetes/clusters
   - If Stackdriver enabled: Cloud Logging and Monitoring

---

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Google Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/best-practices)

---

## 📝 License

This project is provided as-is for educational and learning purposes.

---

## ❓ Questions?

Refer to the inline comments in each file for detailed explanations of specific configurations.

**File Comments Explain:**
- What each file does
- Why it's important
- How variables are used
- What resources are created
- Security considerations

Happy Terraforming! 🚀
