resource "google_cloudbuild_trigger" "cloud_build_generic_trigger" {
  for_each = { for trigger in var.gcp_cloud_build_triggers.triggers : trigger.name => trigger }

  location    = "global"
  name        = "${each.value.name}-trigger"
  description = "Trigger for repo: ${each.value.repo_name}"
  filename    = each.value.filename
  project     = var.gcp_cloud_build_config.project_id

  service_account = "projects/${google_service_account.cloud_build_sa.project}/serviceAccounts/${google_service_account.cloud_build_sa.email}"

  # Fusiona variables específicas con globales
  substitutions = merge(
    var.gcp_cloud_build_triggers.vars_globals, # Variables globales
    each.value.variables                       # Variables específicas del trigger
  )

  tags = [
    "name:${each.value.name}-trigger",
    "terraform:true", 
    "environment:${local.environment_suffix}"
  ]

  trigger_template {
    branch_name = each.value.branch_name
    project_id  = var.gcp_cloud_build_config.project_id
    repo_name   = each.value.repo_name
  }

  depends_on = [google_service_account.cloud_build_sa]
}

locals {
  # Definición de sufijo basado en el entorno
  environment_suffix = (
    var.gcp_cloud_build_config.environment == "qa" 
      ? "tst" 
      : var.gcp_cloud_build_config.environment == "prod" 
      ? "prd" 
      : var.gcp_cloud_build_config.environment
  )
}