resource "azurerm_role_assignment" "devopsutils_vnet_peer" {
  scope              = data.azurerm_virtual_network.devopsutils.id
  role_definition_id = data.azurerm_role_definition.devopsutils_vnet_peer.id
  principal_id       = module.terraform_bootstrap.terraform_client_ids["nomad"].principal_id
}

// This ALLOWS the identity to assign the given roles to another identity.
resource "azurerm_role_assignment" "assign_acr_perms" {
  scope                = data.azurerm_container_registry.devopsutils.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = module.terraform_bootstrap.terraform_client_ids["nomad"].principal_id
  condition_version    = "2.0"

  condition = <<-EOT
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
                 )
                 OR 
                 (
                  @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(data.azurerm_role_definition.acr_task_run.id)}, ${basename(data.azurerm_role_definition.acr_pull.id)}}
                 )
                )
                AND
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
                 )
                 OR 
                 (
                  @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(data.azurerm_role_definition.acr_task_run.id)}, ${basename(data.azurerm_role_definition.acr_pull.id)}}
                 )
                )
                EOT
}

resource "azurerm_role_assignment" "devopsutils_rg_reader" {
  scope                = data.azurerm_resource_group.devopsutils.id
  role_definition_name = "Reader"
  principal_id         = module.terraform_bootstrap.terraform_client_ids["nomad"].principal_id
}

// Usually we would use Azure Policy for this rather than having our identity write the A records themselves
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = data.azurerm_resource_group.devopsutils.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = module.terraform_bootstrap.terraform_client_ids["nomad"].principal_id
}