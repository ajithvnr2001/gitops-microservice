variable "project_id" {
  description = "gcp project id"
  type        = string
}
variable "region" {
  description = "this is the region specified"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "name of the cluster"
  type        = string
  default     = "auto-pilot-cluster"
}