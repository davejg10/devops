resource "azurerm_resource_group" "terraform" {
  name     = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-tf"
  location = var.environment_settings.region
}
resource "azurerm_resource_group" "apps" {
  for_each = var.app_config

  name     = each.value.rg_name
  location = var.environment_settings.region
}

resource "azurerm_management_lock" "terraform_rg" {
  name       = "DontDelete"
  scope      = azurerm_resource_group.terraform.id
  lock_level = "CanNotDelete"
  notes      = "This Resource Group should not be deleted"
}
