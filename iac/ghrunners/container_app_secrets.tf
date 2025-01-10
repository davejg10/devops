data "azurerm_key_vault_secret" "github_access_token" {
  name         = var.github_app_key_secret_name
  key_vault_id = data.terraform_remote_state.devopsutils.outputs.key_vault_id
}
