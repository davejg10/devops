# resource "azurerm_container_registry_task" "build_push_custom_image" {
#   name                  = "build-push-custom-image"
#   container_registry_id = azurerm_container_registry.devops.id
#   platform {
#     os = "Linux"
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   registry_credential {
#     source {
#       login_mode = "None"
#     }
#     custom {
#       login_server = azurerm_container_registry.devops.login_server
#       identity = "[system]"
#     }
#   }

#   file_step {
#     task_file_path = "${path.module}/acb.yaml"
#     # context_path = "/dev/null"
#   }

# }

# resource "azurerm_role_assignment" "build_push_custom_image" {
#   scope                = azurerm_container_registry.devops.id
#   role_definition_name = "AcrPush"
#   principal_id         = azurerm_container_registry_task.build_push_custom_image.identity[0].principal_id
# }

resource "azurerm_container_registry" "devops" {
  name = "acr${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  sku                     = var.acr_sku
  zone_redundancy_enabled = var.acr_zone_redundancy_enabled
}

resource "terraform_data" "create_acr_task" {
  triggers_replace = [
    azurerm_container_registry.devops.id,
  ]

  provisioner "local-exec" {
    command = <<CMD
      TASK_NAME="build_and_push_custom_image"
      system_identity_principal=$(az acr task create -t $TASK_NAME -n github-task -r ${azurerm_container_registry.devops.name} -c /dev/null -f acb.yaml --auth-mode None --assign-identity [system] --base-image-trigger-enabled false --query "identity.principalId" -o tsv)
      az role assignment create --assignee $system_identity_principal --role AcrPush --scope ${azurerm_container_registry.devops.id}
      az acr task credential add -r ${azurerm_container_registry.devops.name} -n $TASK_NAME --login-server ${azurerm_container_registry.devops.login_server} --use-identity [system]
    CMD
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