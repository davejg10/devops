resource "azurerm_log_analytics_workspace" "devops" {
  name = "law-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-${var.environment_settings.identifier}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.devops.name
}