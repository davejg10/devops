resource "azurerm_user_assigned_identity" "container_app_job" {
  name = "id-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-acaj"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
}

resource "azurerm_role_assignment" "container_app_job_fetch_secret" {
  scope                = data.terraform_remote_state.devopsutils.outputs.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.container_app_job.principal_id
}

resource "azurerm_role_assignment" "container_app_job_pull_acr" {
  scope                = data.terraform_remote_state.devopsutils.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app_job.principal_id
}