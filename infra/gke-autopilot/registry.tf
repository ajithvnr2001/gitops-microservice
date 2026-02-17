resource "google_artifact_registry_repository" "my_repo" {
  location      = var.region
  repository_id = "gitops-repo"
  description   = "Docker repository for GitOps Microservices"
  format        = "DOCKER"
}