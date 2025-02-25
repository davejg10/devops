resource "azurerm_data_protection_backup_policy_disk" "disk" {
  name     = "disk-backup"
  vault_id = azurerm_data_protection_backup_vault.vault.id

  backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT12H"]
  default_retention_duration      = "P7D"
  time_zone                       = "GMT Standard Time"
}