
data "azurerm_container_registry" "devopsutils" {
  name                = var.hub_acr_name
  resource_group_name = var.hub_rg_name
}

data "azurerm_log_analytics_workspace" "devopsutils" {
  name                = var.hub_law_name
  resource_group_name = var.hub_rg_name
}

data "azurerm_virtual_network" "devopsutils" {
  name                = var.hub_vnet_name
  resource_group_name = var.hub_rg_name
}

data "azurerm_resource_group" "devopsutils" {
  name = var.hub_rg_name
}

data "azurerm_resource_group" "backup_vault" {
  name = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-backup"
}
data "azurerm_resource_group" "backup_vault_snapshots" {
  name = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-backup-snapshots"
}
data "azurerm_data_protection_backup_vault" "vault" {
  name                = "bv-${var.environment_settings.environment}-${var.environment_settings.region_code}-backup"
  resource_group_name = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-backup"
}

data "azurerm_role_definition" "devopsutils_vnet_peer" {
  name  = "vnet-peer"
  scope = data.azurerm_virtual_network.devopsutils.id
}
data "azurerm_role_definition" "acr_pull" {
  name  = "AcrPull"
  scope = data.azurerm_container_registry.devopsutils.id
}
data "azurerm_role_definition" "acr_push" {
  name  = "AcrPush"
  scope = data.azurerm_container_registry.devopsutils.id
}
data "azurerm_role_definition" "create_backup_instance" {
  name  = "create-backup-instance"
  scope = data.azurerm_data_protection_backup_vault.vault.id
}
data "azurerm_role_definition" "link_to_law" {
  name  = "link-resource-to-log-analytics-workspace"
  scope = data.azurerm_log_analytics_workspace.devopsutils.id
}