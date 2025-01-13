resource "azurerm_role_definition" "vnet_peer" {
  name        = "devopsutils-vnet-peer"
  scope       = data.terraform_remote_state.devops.vnet_id
  description = "A custom role that allows an identity to create a VNet peer to the vnet-glb-uks-devopsutil VNet"

  # WARNING: This allows the identity to delete peers on the central vnet!!  
  permissions {
    actions = []
    data_actions = [
      "Microsoft.ClassicNetwork/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/peer/action",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
      "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.terraform_remote_state.devops.vnet_id
  ]
}

resource "azurerm_role_definition" "run_acr_task" {
  name        = "devopsutils-acr-task-run"
  scope       = data.terraform_remote_state.devops.acr_id
  description = "A custom role that allows an identity to run a pre-made ACR task."

  # WARNING: This allows the identity to delete peers on the central vnet!!  
  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/taskruns/read",
      "Microsoft.ContainerRegistry/registries/taskruns/write"
    ]
    data_actions = []
    not_actions = []
  }

  assignable_scopes = [
    data.terraform_remote_state.devops.acr_id
  ]
}