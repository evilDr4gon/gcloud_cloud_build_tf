resource "google_service_account" "cloud_build_sa" {
  account_id   = var.gcp_cloud_build_config.cloud_build_custom_sa_name
  display_name = "Cloud Build Service Account"
  project      = var.gcp_cloud_build_config.project_id
}

