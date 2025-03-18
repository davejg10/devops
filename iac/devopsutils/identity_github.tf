resource "azurerm_role_assignment" "github_to_acr" {
  scope                = azurerm_container_registry.devops.id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id
}