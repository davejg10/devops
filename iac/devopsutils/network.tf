resource "azurerm_virtual_network" "devops" {
  name                = "vnet-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  location            = var.environment_settings.region
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]
}

output "vnet_name" {
  value = azurerm_virtual_network.devops.name
}