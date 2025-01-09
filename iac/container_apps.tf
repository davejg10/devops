resource "azurerm_container_app_environment" "self_hosted_runners" {
  name = "cae${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}${var.environment_settings.identifier}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  log_analytics_workspace_id = azurerm_log_analytics_workspace.devops.id
}