locals {
  unique_identity_names = distinct([
    for app, config in var.app_config : config.identity_name
  ])
}

resource "azurerm_user_assigned_identity" "terraform" {
  for_each = {
    for identity_name in local.unique_identity_names : identity_name => identity_name
  }
  name = "id-${var.environment_settings.environment}-${var.environment_settings.region_code}-${each.key}-tf"

  resource_group_name = azurerm_resource_group.terraform.name
  location            = azurerm_resource_group.terraform.location
}

resource "azurerm_federated_identity_credential" "github" {
  for_each = {
    for identity_name in local.unique_identity_names : identity_name => identity_name
  }
  name = "${var.github_repository_name}-${var.github_environment}"

  resource_group_name = azurerm_resource_group.terraform.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.terraform[each.key].id
  subject             = "repo:${var.github_organisation_target}/${var.github_repository_name}:environment:${var.github_environment}"
}

output "terraform_identity_ids" {
  value = {
    for identity_name in local.unique_identity_names : identity_name => {
      principal_id = azurerm_user_assigned_identity.terraform[identity_name].principal_id
      client_id    = azurerm_user_assigned_identity.terraform[identity_name].client_id
    } 
  }
}
