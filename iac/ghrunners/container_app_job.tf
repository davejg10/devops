resource "azurerm_container_app_job" "github_runners" {
  name = "aca-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.environment_settings.region
  container_app_environment_id = azurerm_container_app_environment.github_runners.id
  replica_timeout_in_seconds   = 1800

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app_job.id]
  }

  secret {
    name                = var.github_access_token_secret_name
    identity            = azurerm_user_assigned_identity.container_app_job.id
    key_vault_secret_id = azurerm_key_vault_secret.github_access_token.id
  }

  registry {
    server   = data.terraform_remote_state.devopsutils.outputs.acr_login_server
    identity = azurerm_user_assigned_identity.container_app_job.id
  }

  template {
    container {
      name   = "github-runner"
      image  = "${data.terraform_remote_state.devopsutils.outputs.acr_login_server}/github-runners:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      # env {
      #   name  = "APP_ID"
      #   value = var.github_app_id
      # }
      env {
        name        = "ACCESS_TOKEN"
        secret_name = var.github_access_token_secret_name
      }
      env {
        name  = "RUNNER_SCOPE"
        value = "repo"
      }
      # env {
      #   name  = "ORG_NAME"
      #   value = var.github_organization
      # }
      env {
        name  = "APPSETTING_WEBSITE_SITE_NAME"
        value = "az-cli-workaround"
      }
      env {
        name  = "REPO_URL"
        value = "https://github.com/davejg10/devops"
      }
      env {
        name  = "MSI_CLIENT_ID"
        value = azurerm_user_assigned_identity.container_app_job.client_id
      }
      env {
        name  = "EPHEMERAL"
        value = "1"
      }
      env {
        name  = "RUNNER_NAME_PREFIX"
        value = var.project
      }
    }
  }

  event_trigger_config {
    scale {
      rules {
        name             = "github-runner-scaling-rule"
        custom_rule_type = "github-runner"
        metadata = {
          "owner"          = var.github_organization
          "runnerScope"    = "org"
          "applicationID"  = var.github_app_id
          "installationID" = var.github_installation_id
        }
        authentication {
          secret_name       = var.github_access_token_secret_name
          trigger_parameter = "appKey"
        }
      }
    }
  }
}