# Terraform Cloud Build Module

Este módulo de Terraform permite la configuración de **Cloud Build** en Google Cloud Platform (GCP). Crea una cuenta de servicio para Cloud Build, asigna roles personalizados y configura disparadores (triggers) para integrar con repositorios de código.

## Requisitos

- **Terraform**: `>= 1.0.0`
- **Proveedor de GCP**: `google` (versión `>= 3.5.0` o superior)
- **Cuenta en Google Cloud**: Necesitas una cuenta con permisos para crear y administrar recursos en GCP, como IAM, Service Accounts y Cloud Build.

## Variables

Este módulo acepta las siguientes variables de entrada:

### `gcp_cloud_build_config` (object)

Configuración general para Cloud Build. Define los parámetros necesarios para crear la cuenta de servicio y configurar los roles en el proyecto de GCP.

| Nombre                               | Descripción                                                                                      | Tipo           | Valor Predeterminado |
|--------------------------------------|--------------------------------------------------------------------------------------------------|----------------|----------------------|
| `environment`                        | El entorno del proyecto (dev, qa, prod).                                                          | `string`       | N/A                  |
| `project_id`                         | ID del proyecto en GCP.                                                                           | `string`       | N/A                  |
| `cloud_build_custom_sa_name`         | Nombre de la cuenta de servicio personalizada para Cloud Build.                                   | `string`       | N/A                  |
| `cloud_build_custom_sa_description`  | Descripción de la cuenta de servicio personalizada.                                                | `string`       | N/A                  |
| `cloud_build_custom_sa_roles`        | Lista de roles personalizados que se asignarán a la cuenta de servicio.                          | `list(string)` | `[]`                 |

#### Validación de la variable `environment`:

La variable `environment` debe ser uno de los siguientes valores: `dev`, `qa`, `prod`. De no ser así, se generará un mensaje de error.

### `gcp_cloud_build_triggers` (object)

Configuración para los triggers de Cloud Build. Define la lista de disparadores, con sus respectivas configuraciones, y las variables globales que se aplican a todos los triggers.

| Nombre           | Descripción                                                                                      | Tipo               | Valor Predeterminado |
|------------------|--------------------------------------------------------------------------------------------------|--------------------|----------------------|
| `triggers`       | Lista de objetos que definen los triggers de Cloud Build. Cada trigger contiene información sobre el nombre, repositorio, rama y archivo de configuración. | `list(object)`     | N/A                  |
| `vars_globals`   | Variables globales que se aplican a todos los triggers de la lista `triggers`.                    | `map(string)`      | `{}`                 |

#### Subvariables de `triggers` (lista de objetos)

Cada objeto dentro de `triggers` tiene la siguiente estructura:

| Nombre           | Descripción                                                                                      | Tipo               | Valor Predeterminado |
|------------------|--------------------------------------------------------------------------------------------------|--------------------|----------------------|
| `name`           | El nombre del trigger.                                                                            | `string`           | N/A                  |
| `repo_name`      | El nombre del repositorio de código que activará el trigger.                                      | `string`           | N/A                  |
| `branch_name`    | El nombre de la rama en el repositorio que activará el trigger.                                   | `string`           | N/A                  |
| `filename`       | El nombre del archivo de configuración de Cloud Build que se utilizará para el trigger.          | `string`           | N/A                  |
| `variables`      | Un conjunto de variables específicas para este trigger, que se combinan con las variables globales. | `map(string)`      | `{}`                 |


## Salidas

Este módulo no define salidas específicas, pero realiza la creación y configuración de los siguientes recursos:

- **Cuentas de servicio**: Se crea una cuenta de servicio personalizada para Cloud Build.
- **Roles IAM**: Se asignan roles a la cuenta de servicio.
- **Triggers**: Se configuran triggers para integrar Cloud Build con repositorios de código.

## Ejemplo de Uso

Este es un ejemplo de cómo usar el módulo para crear una cuenta de servicio personalizada y configurar triggers de Cloud Build en tu proyecto de GCP:

1. Ejemplo con un solo trigger:

```h
module "cloud-build" {
  source  = "evilDr4gon/cloud-build/google"
  version = "1.0.0"


  gcp_cloud_build_config = {
    environment                       = "qa"
    project_id                        = "siman-pos-project-tst"
    cloud_build_custom_sa_name        = "cloud-build-sa"
    cloud_build_custom_sa_description = "temporal"
    cloud_build_custom_sa_roles       = ["roles/cloudbuild.builds.editor", "roles/storage.admin"]
  }

  gcp_cloud_build_triggers = {
    triggers = [
      {
        name        = "example-trigger"
        repo_name   = "mi-repo"
        branch_name = "main"
        filename    = "cloudbuild.yaml"
        variables = {
          "var1" = "value1"
        }
      }
    ]
    vars_globals = {
      "global_var" = "global_value"
    }
  }
}
```

Este ejemplo crea la cuenta de servicio para Cloud Build, asigna roles personalizados, y configura un trigger que ejecuta un archivo cloudbuild.yaml desde un repositorio en el branch main.




2. Ejemplo con varios triggers:

```h
module "cloud-build" {
  source  = "evilDr4gon/cloud-build/google"
  version = "1.0.0"

  gcp_cloud_build_config = {
    environment                       = "qa"
    project_id                        = "siman-pos-project-tst"
    cloud_build_custom_sa_name        = "cloud-build-sa"
    cloud_build_custom_sa_description = "temporal"
    cloud_build_custom_sa_roles       = ["roles/cloudbuild.builds.editor", "roles/storage.admin"]
  }

  gcp_cloud_build_triggers = {
    triggers = [
      {
        name        = "example-trigger"
        repo_name   = "mi-repo"
        branch_name = "main"
        filename    = "cloudbuild.yaml"
        variables = {
          "var1" = "value1"
        }
      },
      {
        name        = "example-trigger2"
        repo_name   = "mi-repo2"
        branch_name = "main"
        filename    = "cloudbuild.yaml"
        variables = {
          "var1" = "value1"
        }
      },
      
      # .... Otros triggers 

    ]
    vars_globals = {
      "global_var" = "global_value"
    }
  }
}

```

Este ejemplo crea la cuenta de servicio para Cloud Build, asigna roles personalizados, y configura dos triggers que ejecutan archivos cloudbuild.yaml desde un repositorio. Uno de los triggers se ejecuta en el branch main y el otro en el branch develop del mismo repositorio.

## Autor

Este módulo fue desarrollado por Jose Reynoso.
