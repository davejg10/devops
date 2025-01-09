resource "azurerm_key_vault_secret" "github_app_key" {
  name         = var.github_app_key_secret_name
  value        = var.github_app_key
  key_vault_id = data.terraform_remote_state.devopsutils.outputs.key_vault_id
}
