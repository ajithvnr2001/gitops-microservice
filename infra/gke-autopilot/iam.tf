# 1. Create a Google Service Account for GitHub Actions
resource "google_service_account" "github_actions" {
  account_id   = "github-actions-sa"
  display_name = "GitHub Actions Service Account"
}

# 2. Grant permissions to the Service Account
# Allow pushing to Artifact Registry
resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Allow deploying to GKE (we will need this later)
resource "google_project_iam_member" "gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# 3. Create the Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool-3"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions"
}

# 4. Create the Identity Provider (The "Handshake" Config)
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  attribute_condition = "assertion.repository == 'ajithvnr2001/gitops-microservice'"


  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# 5. Allow YOUR Repository to Impersonate the Service Account
# IMPORTANT: You must replace 'YOUR_GITHUB_USER/YOUR_REPO_NAME' below!
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  
  # CHANGE THIS LINE to match your GitHub details (e.g., "ajithvnr2001/gitops-microservice")
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/ajithvnr2001/gitops-microservice"
}

# 6. Output the Provider Name (We need this for the GitHub Actions YAML)
output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github_provider.name
}

output "service_account_email" {
  value = google_service_account.github_actions.email
}