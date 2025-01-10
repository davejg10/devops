data "azurerm_key_vault_secret" "github_access_token" {
  name         = var.github_access_token_secret_name
  # value        = var.github_access_token
  key_vault_id = data.terraform_remote_state.devopsutils.outputs.key_vault_id

  # lifecycle {
  #   ignore_changes = [
  #     value  # Ignore changes to the 'value' attribute
  #   ]
  # }
}
