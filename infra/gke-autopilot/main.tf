resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Enable Autopilot Mode
  enable_autopilot = true

  # Attach to our VPC and Subnet
  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  # Networking Configuration
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  # Security: Private Cluster Config
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }

  # Deletion Protection
  deletion_protection = false
}