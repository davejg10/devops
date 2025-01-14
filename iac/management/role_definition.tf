resource "azurerm_role_definition" "vnet_peer" {
  name        = "devopsutils-vnet-peer"
  scope       = data.terraform_remote_state.devopsutils.outputs.vnet_id
  description = "A custom role that allows an identity to create a VNet peer to the vnet-glb-uks-devopsutil VNet"

  # WARNING: This allows the identity to delete peers on the central vnet!!  
  permissions {
    actions = [
      "Microsoft.ClassicNetwork/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete"
    ]
    data_actions = []
    not_actions = []
  }

  assignable_scopes = [
    data.terraform_remote_state.devopsutils.outputs.vnet_id
  ]
}

data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
  scope = data.terraform_remote_state.devopsutils.outputs.acr_id
}

resource "azurerm_role_definition" "run_acr_task" {
  name        = "devopsutils-acr-task-run"
  scope       = data.terraform_remote_state.devopsutils.outputs.acr_id
  description = "A custom role that allows an identity to run a pre-made ACR task."

  # This allows the identity to execute a pre-built task using `az acr task run`
  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/runs/listLogSasUrl/action",
      "Microsoft.ContainerRegistry/registries/tasks/write",
      "*/read",
      "Microsoft.ContainerRegistry/registries/listBuildSourceUploadUrl/action",
      "Microsoft.ContainerRegistry/registries/tasks/listDetails/action",
      "Microsoft.ContainerRegistry/registries/scheduleRun/action"
    ]
    data_actions = []
    not_actions = []
  }

  assignable_scopes = [
    data.terraform_remote_state.devopsutils.outputs.acr_id
  ]
}