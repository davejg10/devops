resource "azurerm_container_app_environment" "github_runners" {
  name = "acae-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = var.environment_settings.region
  log_analytics_workspace_id = data.terraform_remote_state.devopsutils.outputs.log_analytics_workspace_id

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}