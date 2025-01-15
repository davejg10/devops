locals {
  hub_environment_settings = {
    app_name = "devopsutils"
    region_code = "uks"
    environment = "glb"
  }
}

data "azurerm_container_registry" "devopsutils" {
  name                = "acr${local.hub_environment_settings.environment}${local.hub_environment_settings.region_code}${local.hub_environment_settings.app_name}"
  resource_group_name = "rg-${local.hub_environment_settings.environment}-${local.hub_environment_settings.region_code}-${local.hub_environment_settings.app_name}"
}

data "azurerm_virtual_network" "devopsutils" {
  name                = "vnet-${local.hub_environment_settings.environment}-${local.hub_environment_settings.region_code}-${local.hub_environment_settings.app_name}"
  resource_group_name = "rg-${local.hub_environment_settings.environment}-${local.hub_environment_settings.region_code}-${local.hub_environment_settings.app_name}"
}

data "azurerm_resource_group" "devopsutils" {
  name                = "rg-${local.hub_environment_settings.environment}-${local.hub_environment_settings.region_code}-${local.hub_environment_settings.app_name}"
}

data "azurerm_role_definition" "devopsutils_vnet_peer" {
  name  = "vnet-peer"
  scope = data.azurerm_virtual_network.devopsutils.id
}
data "azurerm_role_definition" "acr_pull" {
  name  = "AcrPull"
  scope = data.azurerm_container_registry.devopsutils.id
}
data "azurerm_role_definition" "acr_task_run" {
  name  = "acr-task-run"
  scope = data.azurerm_container_registry.devopsutils.id
}