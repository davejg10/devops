resource "azurerm_storage_account" "terraform" {
  name                     = "st${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}tf"
  resource_group_name      = azurerm_resource_group.terraform.name
  location                 = azurerm_resource_group.terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "statefile" {
  for_each = var.app_config

  name                  = each.value.state_container_name
  storage_account_id    = azurerm_storage_account.terraform.id
  container_access_type = "private"
}