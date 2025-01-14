resource "azurerm_container_registry" "devops" {
  name = "acr${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  sku                     = var.acr_sku
  zone_redundancy_enabled = var.acr_zone_redundancy_enabled
  public_network_access_enabled = var.acr_public_network_access_enabled
}

locals {
  acr_task_file_path = "${path.module}/acb.yaml"
  create_acr_task_file_path = "${path.module}/create_acr_task.sh"
}

// Create a diff so the create task is triggered if any changes occur in either file.
resource "terraform_data" "create_acr_task_diff" {
  input = "${filebase64(local.create_acr_task_file_path)},${filebase64(local.acr_task_file_path)}"
}

resource "terraform_data" "create_acr_task" {
  triggers_replace = [
    azurerm_container_registry.devops.id,
    terraform_data.create_acr_task_diff
  ]

  provisioner "local-exec" {
    command = "chmod +x ${local.create_acr_task_file_path} && ./${local.create_acr_task_file_path}"

    environment = {
      ACR_NAME = azurerm_container_registry.devops.name
      ACR_LOGIN_SERVER = azurerm_container_registry.devops.login_server
      ACR_ID = azurerm_container_registry.devops.id
    }
  }
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