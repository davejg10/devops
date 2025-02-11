resource "azurerm_role_definition" "vnet_peer" {
  name        = "vnet-peer"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "A custom role that allows an identity to create a VNet peer"

  # WARNING: This allows the identity to delete peers on the central vnet!!  
  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete"
    ]
    data_actions = []
    not_actions  = []
  }
}

resource "azurerm_role_definition" "run_acr_task" {
  name        = "acr-task-run"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "A custom role that allows an identity to build & push & import an image to ACR using quick tasks."

  # This allows the identity to execute a pre-built task using `az acr task run`
  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/importImage/action",
      "Microsoft.ContainerRegistry/registries/runs/listLogSasUrl/action",
      "Microsoft.ContainerRegistry/registries/tasks/write",
      "*/read",
      "Microsoft.ContainerRegistry/registries/listBuildSourceUploadUrl/action",
      "Microsoft.ContainerRegistry/registries/tasks/listDetails/action",
      "Microsoft.ContainerRegistry/registries/scheduleRun/action"
    ]
    data_actions = []
    not_actions  = []
  }
}

resource "azurerm_role_definition" "create_backup_instance" {
  name        = "create-backup-instance"
  scope       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  description = "A custom role that allows an identity to create a backup instance with an Azure Backup Vault."

  permissions {
    actions = [
      "Microsoft.DataProtection/backupVaults/backupInstances/read",
      "Microsoft.DataProtection/backupVaults/backupInstances/operationResults/read",
      "Microsoft.DataProtection/backupVaults/backupInstances/write",
      "Microsoft.DataProtection/backupVaults/deletedBackupInstances/read",
      "Microsoft.DataProtection/backupVaults/backupPolicies/read",
      "Microsoft.DataProtection/backupVaults/backupInstances/recoveryPoints/read",
      "Microsoft.DataProtection/backupVaults/backupInstances/findRestorableTimeRanges/action",
      "Microsoft.DataProtection/backupVaults/read",
      "Microsoft.DataProtection/backupVaults/operationResults/read",
      "Microsoft.DataProtection/backupVaults/operationStatus/read",
      "Microsoft.DataProtection/backupVaults/backupInstances/backup/action",
      "Microsoft.DataProtection/backupVaults/backupInstances/validateRestore/action",
      "Microsoft.DataProtection/backupVaults/backupInstances/restore/action",
      "Microsoft.DataProtection/backupVaults/backupInstances/validateForModifyBackup/action",
      "Microsoft.DataProtection/backupVaults/backupInstances/delete"
    ]
    data_actions = []
    not_actions  = []
  }
}