variable "gcp_cloud_build_config" {
  description = "Configuracion general de Cloud Build"
  type = object({

    # ENTORNO DEL PROYECTO
    environment = string

    # ID DE PROYECTO GCP
    project_id = string

    cloud_build_custom_sa_name = string
    cloud_build_custom_sa_description = string
    cloud_build_custom_sa_roles = list(string)


    })
    validation {
        condition     = contains(["dev", "qa", "prod"], var.gcp_cloud_build_config.environment)
        error_message = "El valor de 'environment' debe ser uno de los siguientes: 'dev', 'qa', 'prod'."
    }
}

variable "gcp_cloud_build_triggers" {
  type = object({
    triggers = list(object({
      name         = string
      repo_name    = string
      branch_name  = string
      filename     = string
      variables    = map(string)
    }))
    vars_globals = map(string)
  })
}
