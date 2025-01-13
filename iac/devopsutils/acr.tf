locals {
  uk_south_acr_azure_ip_ranges = jsondecode(file("${path.module}/uk_south.json")).ip_ranges
  # uk_west_acr_azure_ip_ranges = "${path.cwd}/uk_south.json"
}

# variable "uk_south_acr_azure_ip_ranges" {
#   type = string
#   default = "uk_south.json"
# }

# resource "null_resource" "fetch_uk_south_acr_ips" {
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     # Logs into the Service principal that has subscription permission over the core network.
#     command = <<CMD
#       curl -o ips.json https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20250106.json
#       jq -r '.values[] | select(.name == "AzureContainerRegistry.UKSouth") | {ip_ranges: .properties.addressPrefixes}' ips.json > local.uk_south_acr_azure_ip_ranges
#       jq -r '.values[] | select(.name == "AzureContainerRegistry.UKWest") | {ip_ranges: .properties.addressPrefixes}' ips.json > local.uk_west_acr_azure_ip_ranges
#     CMD
#   }
# }


resource "azurerm_container_registry" "devops" {
  name = "acr${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"

  resource_group_name     = data.azurerm_resource_group.rg.name
  location                = var.environment_settings.region
  sku                     = var.acr_sku
  zone_redundancy_enabled = var.acr_zone_redundancy_enabled

  network_rule_set {
    default_action = "Deny"

    ip_rule = [
      for ip_range in local.uk_south_acr_azure_ip_ranges : {
        action   = "Allow"
        ip_range = ip_range
      } if !strcontains(ip_range, ":")
    ]

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