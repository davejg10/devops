locals {
  dev_nomad_environment_settings = {
    region         = "uksouth"
    region_code    = "uks"
    environment    = "dev"
    app_name       = "nomad"
    identifier     = "tf"
    github_repository_name = "nomad_infra"
  } 
}

resource "azurerm_resource_group" "dev_nomad_01_tf" {
  name     = "rg-${local.dev_nomad_environment_settings.environment}-${local.dev_nomad_environment_settings.region_code}-${local.dev_nomad_environment_settings.app_name}-${local.dev_nomad_environment_settings.identifier}"
  location = local.dev_nomad_environment_settings.region
}
resource "azurerm_resource_group" "dev_nomad_01" {
  name     = "rg-${local.dev_nomad_environment_settings.environment}-${local.dev_nomad_environment_settings.region_code}-${local.dev_nomad_environment_settings.app_name}-01"
  location = local.dev_nomad_environment_settings.region
}
resource "azurerm_management_lock" "dev_nomad_01_tf" {
  name       = "DontDelete"
  scope      = azurerm_resource_group.dev_nomad_01_tf.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group should not be deleted"
}

resource "azurerm_storage_account" "dev_nomad_01_tf" {
  name                     = "st${local.dev_nomad_environment_settings.environment}${local.dev_nomad_environment_settings.region_code}${local.dev_nomad_environment_settings.app_name}${local.dev_nomad_environment_settings.identifier}"
  resource_group_name      = azurerm_resource_group.dev_nomad_01_tf.name
  location                 = azurerm_resource_group.dev_nomad_01_tf.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "statefile" {
  name                  = "nomad-backend"
  storage_account_id    = azurerm_storage_account.dev_nomad_01_tf.id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "dev_nomad_01_tf" {
  name = "id-${local.dev_nomad_environment_settings.environment}-${local.dev_nomad_environment_settings.region_code}-${local.dev_nomad_environment_settings.app_name}-${local.dev_nomad_environment_settings.identifier}"

  resource_group_name = azurerm_resource_group.dev_nomad_01_tf.name
  location            = azurerm_resource_group.dev_nomad_01_tf.location
}

resource "azurerm_role_assignment" "dev_nomad_01_vnet_peer" {
  scope                = data.terraform_remote_state.devopsutils.outputs.vnet_id
  role_definition_id   = azurerm_role_definition.vnet_peer.role_definition_resource_id
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

// This ALLOWS the identity to assign the given roles to another identity.
resource "azurerm_role_assignment" "dev_nomad_01_assign_acr_perms" {
  scope                = data.terraform_remote_state.devopsutils.outputs.acr_id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
  condition_version    = "2.0"

  condition = <<-EOT
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
                 )
                 OR 
                 (
                  @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(azurerm_role_definition.run_acr_task.role_definition_id)}, ${basename(data.azurerm_role_definition.acr_pull.role_definition_id)}}
                 )
                )
                AND
                (
                 (
                  !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
                 )
                 OR 
                 (
                  @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${basename(azurerm_role_definition.run_acr_task.role_definition_id)}, ${basename(data.azurerm_role_definition.acr_pull.role_definition_id)}}
                 )
                )
                EOT
}

resource "azurerm_role_assignment" "dev_nomad_01_rg_contributor" {
  scope                = azurerm_resource_group.dev_nomad_01.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

resource "azurerm_role_assignment" "dev_nomad_01_rg_uaa" {
  scope                = azurerm_resource_group.dev_nomad_01.id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

resource "azurerm_role_assignment" "dev_nomad_01_tf_storage_blob_owner" {
  scope                = azurerm_storage_container.statefile.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

resource "azurerm_role_assignment" "dev_nomad_01_rg_reader" {
  scope                = data.terraform_remote_state.devopsutils.outputs.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

// Usually we would use Azure Policy for this rather than having our identity write the A records themselves
resource "azurerm_role_assignment" "dev_nomad_01_rg_dns_contributor" {
  scope                = data.terraform_remote_state.devopsutils.outputs.resource_group_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.dev_nomad_01_tf.principal_id
}

resource "azurerm_federated_identity_credential" "dev_nomad_01_tf" {
  name = "${local.dev_nomad_environment_settings.github_repository_name}-${local.dev_nomad_environment_settings.environment}"

  resource_group_name = azurerm_resource_group.dev_nomad_01_tf.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.dev_nomad_01_tf.id
  subject             = "repo:${var.github_organisation_target}/${local.dev_nomad_environment_settings.github_repository_name}:environment:${local.dev_nomad_environment_settings.environment}"
}

output "dev_nomad_01_azure_client_id" {
  value = azurerm_user_assigned_identity.dev_nomad_01_tf.client_id
}