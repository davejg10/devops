resource "azuread_application" "hetzner" {
  display_name = "sp-${var.environment_settings.environment}-hetzner-scraper"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "hetzner" {
  client_id                    = azuread_application.hetzner.client_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}

// Give the Github Terraform Managed identity permission to READ the directory

data "azuread_service_principal" "github_terraform" {
  object_id = module.terraform_bootstrap.terraform_identity_ids["nomad"].principal_id # Get the SP Object ID from the UAMI resource
}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

locals {
  # Find the app role object where the value is "Application.Read.All"
  app_read_all_role = one([
    for role in azuread_service_principal.msgraph.app_roles : role if role.value == "Application.Read.All"
  ])
}

resource "azuread_app_role_assignment" "github_terraform_graph_read_all" {
  principal_object_id = data.azuread_service_principal.github_terraform.object_id 

  resource_object_id = azuread_service_principal.msgraph.object_id

  app_role_id = local.app_read_all_role.id 
}