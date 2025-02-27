resource "azurerm_resource_group" "backup" {
  name     = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  location = var.environment_settings.region
}

resource "azurerm_resource_group" "snapshots" {
  name     = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-snapshots"
  location = var.environment_settings.region
}

resource "azurerm_data_protection_backup_vault" "vault" {
  name                = "bv-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  resource_group_name = azurerm_resource_group.backup.name
  location            = azurerm_resource_group.backup.location
  datastore_type      = "OperationalStore"
  redundancy          = "ZoneRedundant"
  soft_delete         = var.soft_delete
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "snapshot_contributor" {
  scope                = azurerm_resource_group.snapshots.id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = azurerm_data_protection_backup_vault.vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "disk_backup_reader" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Disk Backup Reader"
  principal_id         = azurerm_data_protection_backup_vault.vault.identity[0].principal_id
}