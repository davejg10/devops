resource "azurerm_role_assignment" "owner" {
  for_each = var.app_config

  scope                = azurerm_resource_group.apps[each.key].id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.terraform[each.value.identity_name].principal_id
  principal_type     = "ServicePrincipal"
}

resource "azurerm_role_assignment" "terraform_state_owner" {
  for_each = var.app_config

  scope                = azurerm_storage_container.statefile[each.key].id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.terraform[each.value.identity_name].principal_id
  principal_type     = "ServicePrincipal"
}