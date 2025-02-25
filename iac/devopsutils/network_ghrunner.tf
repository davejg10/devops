resource "azurerm_subnet" "ghrunner" {
  name                 = "snt-ghrunners"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefixes     = [var.ghrunner_subnet_address_prefixes]

  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.Sql"
  ]

  delegation {
    name = "containerapp-delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_network_security_group" "ghrunner_subnet" {
  name                = "nsg-ghrunner-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
}
resource "azurerm_subnet_network_security_group_association" "ghrunner_subnet" {
  subnet_id                 = azurerm_subnet.ghrunner.id
  network_security_group_id = azurerm_network_security_group.ghrunner_subnet.id
}

output "ghrunner_subnet_name" {
  value = azurerm_subnet.ghrunner.name
}
output "ghrunner_subnet_id" {
  value = azurerm_subnet.ghrunner.id
}
output "ghrunner_subnet_address_prefix" {
  value = azurerm_subnet.ghrunner.address_prefixes[0]
}