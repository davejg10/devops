resource "azurerm_log_analytics_workspace" "devops" {
  name = "law-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region

  sku                        = "PerGB2018"
  retention_in_days          = 30
  internet_ingestion_enabled = var.law_internet_ingestion_enabled
}

resource "azurerm_monitor_private_link_scope" "devops" {
  name = "ampls-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name   = data.azurerm_resource_group.rg.name
  ingestion_access_mode = "PrivateOnly"
  query_access_mode     = "Open"
}

resource "azurerm_monitor_private_link_scoped_service" "devops" {
  name = "ampls-service-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  scope_name          = azurerm_monitor_private_link_scope.devops.name
  linked_resource_id  = azurerm_log_analytics_workspace.devops.id
}

resource "azurerm_private_endpoint" "ampls" {
  name = "pe-ampls-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "pe-ampls-serviceconnection-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.devops.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "dns-group-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.all_zones["blob"].id,
      azurerm_private_dns_zone.all_zones["monitor1"].id,
      azurerm_private_dns_zone.all_zones["monitor2"].id,
      azurerm_private_dns_zone.all_zones["monitor3"].id,
      azurerm_private_dns_zone.all_zones["monitor4"].id,
    ]
  }
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.devops.name
}
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.devops.id
}