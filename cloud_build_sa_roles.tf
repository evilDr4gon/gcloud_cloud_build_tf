resource "google_project_iam_member" "cloud_build_roles" {
  for_each = toset(var.gcp_cloud_build_config.cloud_build_custom_sa_roles)

  project = var.gcp_cloud_build_config.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}