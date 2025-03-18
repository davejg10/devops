// This was private but it was costing 40 quid a month so making it public
// See commit feature/acr-tasks (#6) for private ACR
resource "azurerm_container_registry" "devops" {
  name = "acr${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"

  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = var.environment_settings.region
  sku                           = var.acr_sku
  zone_redundancy_enabled       = var.acr_zone_redundancy_enabled
  public_network_access_enabled = var.acr_public_network_access_enabled
}

output "acr_name" {
  value = azurerm_container_registry.devops.name
}
output "acr_id" {
  value = azurerm_container_registry.devops.id
}
output "acr_login_server" {
  value = azurerm_container_registry.devops.login_server
}

