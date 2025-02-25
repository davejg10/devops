// This was private but making it public to save major costs see NOM-42/data-services (#12)
resource "azurerm_log_analytics_workspace" "devops" {
  name = "law-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region

  sku                        = "PerGB2018"
  retention_in_days          = 30
  internet_ingestion_enabled = var.law_internet_ingestion_enabled
  daily_quota_gb             = var.law_daily_quota_gb
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.devops.name
}
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.devops.id
}