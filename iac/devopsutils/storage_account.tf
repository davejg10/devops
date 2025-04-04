resource "azurerm_storage_account" "central" {
  name                      = "st${var.environment_settings.environment}${var.environment_settings.region_code}${var.environment_settings.app_name}"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = var.environment_settings.region

  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS" 
}

resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.central.name
  container_access_type = "blob"
}

resource "azurerm_cdn_profile" "central" {
  name                = "cdn${var.environment_settings.environment}profile"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "northeurope"
  sku                 = "Standard_Microsoft"
}

resource "azurerm_cdn_endpoint" "central_blob" {
  name                          = "st-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
  profile_name                  = azurerm_cdn_profile.central.name
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = "northeurope"
  origin_host_header            = azurerm_storage_account.central.primary_blob_host
  querystring_caching_behaviour = "IgnoreQueryString"

  origin {
    name      = "storageOrigin" # An arbitrary name for the origin
    host_name = azurerm_storage_account.central.primary_blob_host
  }
}
