resource "azurerm_container_registry" "devops" {
  name = "acr${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  sku                     = var.acr_sku
  zone_redundancy_enabled = var.acr_zone_redundancy_enabled
}

// Required to pass under Azure trusted service and therefore bypass blocking network ACL
resource "azurerm_container_registry_task" "build_and_push" {
  name                  = "build-and-push-task"
  container_registry_id = azurerm_container_registry.devops.id
  platform {
    os = "Linux"

  }

  identity {
    type = "SystemAssigned"
  }

  is_system_task = true
}

resource "azurerm_role_assignment" "acr_task_build_and_push" {
  scope                = azurerm_container_registry.devops.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_container_registry_task.build_and_push.identity[0].principal_id
}

resource "azurerm_private_endpoint" "acr" {
  name = "pe-acr-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "pe-acr-registry-serviceconnection-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
    private_connection_resource_id = azurerm_container_registry.devops.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-acr-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.all_zones["acr"].id]
  }
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