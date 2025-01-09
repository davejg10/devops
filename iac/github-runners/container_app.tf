resource "azurerm_container_app" "github_runners" {
  name = "aca-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-${var.environment_settings.identifier}"
  container_app_environment_id = azurerm_container_app_environment.github_runners.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app_job.id]
  }

  secret {
    name = var.github_app_key_secret_name
    identity = azurerm_user_assigned_identity.container_app_job.id
    key_vault_secret_id = azurerm_key_vault_secret.github_app_key.resource_id
  }

  registry {
    server = azurerm_container_registry.devops.login_server
    identity = azurerm_user_assigned_identity.container_app_job.id
  }

  template {
    container {
      name   = "github-runner"
      image  = "${azurerm_container_registry.devops.login_server}/self-hosted-runners:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name = "APP_ID"
        value = var.github_app_id
      }
      env {
        name = "APP_PRIVATE_KEY"
        secret_name = var.github_app_key_secret_name
      }
      env {
        name = "RUNNER_SCOPE"
        value = "org"
      }
      env {
        name = "ORG_NAME"
        value = var.github_organization
      }
      env {
        name = "APPSETTING_WEBSITE_SITE_NAME"
        value = "az-cli-workaround"
      }
      env {
        name = "MSI_CLIENT_ID"
        value = azurerm_user_assigned_identity.container_app_job.client_id
      }
      env {
        name = "EPHEMERAL"
        value = "1"
      }
      env {
        name = "RUNNER_NAME_PREFIX"
        value = var.project
      }
    }

    custom_scale_rule {
      name = "github-runner-scaling-rule"
      custom_rule_type = "github-runner"
      metadata = {
        "owner" = var.github_organization
        "runnerScope" = "org"
        "applicationID" = var.github_app_id
        "installationID" = var.github_installation_id
      }
      authentication {
        secret_name = var.github_app_key_secret_name
        trigger_parameter = "appKey"
      }
    }
  }

}