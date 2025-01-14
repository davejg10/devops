resource "azurerm_subnet" "private_endpoints" {
  name                 = "snt-privateendpoints"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefixes     = [var.private_endpoint_subnet_address_prefixes]

}

resource "azurerm_network_security_group" "private_endpoints_subnet" {
  name                = "nsg-private-endpoints-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
}
resource "azurerm_subnet_network_security_group_association" "private_endpoints_subnet" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints_subnet.id
}