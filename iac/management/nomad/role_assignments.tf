resource "azurerm_role_assignment" "devopsutils_vnet_peer" {
  scope              = data.azurerm_virtual_network.devopsutils.id
  role_definition_id = data.azurerm_role_definition.devopsutils_vnet_peer.id
  principal_id       = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type     = "ServicePrincipal"
}

// This ALLOWS the identity to assign the given roles to another identity.
resource "azurerm_role_assignment" "devopsutils_acr_perms" {
  scope                = data.azurerm_container_registry.devopsutils.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  condition_version    = "2.0"
  principal_type       = "ServicePrincipal"

  condition = <<-EOT
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
                 )
                 OR 
                 (
                  @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(data.azurerm_role_definition.acr_push.id)}, ${basename(data.azurerm_role_definition.acr_pull.id)}}
                 )
                )
                AND
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
                 )
                 OR 
                 (
                  @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(data.azurerm_role_definition.acr_push.id)}, ${basename(data.azurerm_role_definition.acr_pull.id)}}
                 )
                )
                EOT
}

resource "azurerm_role_assignment" "devopsutils_law" {
  scope              = data.azurerm_log_analytics_workspace.devopsutils.id
  role_definition_id = data.azurerm_role_definition.link_to_law.id
  principal_id       = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "devopsutils_rg_reader" {
  scope                = data.azurerm_resource_group.devopsutils.id
  role_definition_name = "Reader"
  principal_id         = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type       = "ServicePrincipal"
}
resource "azurerm_role_assignment" "backup_vault_rg_reader" {
  scope                = data.azurerm_resource_group.backup_vault.id
  role_definition_name = "Reader"
  principal_id         = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type       = "ServicePrincipal"
}
resource "azurerm_role_assignment" "backup_vault_snapshots_rg_reader" {
  scope                = data.azurerm_resource_group.backup_vault_snapshots.id
  role_definition_name = "Reader"
  principal_id         = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type       = "ServicePrincipal"
}

// Usually we would use Azure Policy for this rather than having our identity write the A records themselves
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = data.azurerm_resource_group.devopsutils.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "create_backup_instance_in_vault" {
  scope              = data.azurerm_data_protection_backup_vault.vault.id
  role_definition_id = data.azurerm_role_definition.create_backup_instance.id
  principal_id       = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id
  principal_type     = "ServicePrincipal"
}
