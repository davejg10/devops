resource "azurerm_key_vault" "devops" {
  name = "kv-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.environment_settings.region
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = var.kv_soft_delete_retention_days
  purge_protection_enabled   = var.kv_purge_protection_enabled
  enable_rbac_authorization  = true

  sku_name = var.key_vault_sku_name

  // Was going to whitelist github runner ips but there are > 4000 ranges!
  // Public until we create self-hosted runners
  public_network_access_enabled = var.kv_public_network_access_enabled
  #   network_acls {
  #     default_action = "Allow"
  #   }
}

resource "azurerm_role_assignment" "github_deployer" {
  scope                = data.terraform_remote_state.devopsutils.outputs.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

output "key_vault_name" {
  value = azurerm_key_vault.devops.name
}
output "key_vault_id" {
  value = azurerm_key_vault.devops.id
}