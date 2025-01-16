environment_settings = {
  region      = "uksouth"
  region_code = "uks"
  environment = "glb"
  app_name    = "devopsutils"
}

// Networking
vnet_address_space = "11.0.0.0/18"

ghrunner_subnet_address_prefixes         = "11.0.0.0/24"
private_endpoint_subnet_address_prefixes = "11.0.1.0/26"

// Azure Container Registry
acr_sku                           = "Basic"
acr_zone_redundancy_enabled       = false
acr_public_network_access_enabled = true

// Key Vault
key_vault_sku_name               = "standard"
kv_purge_protection_enabled      = "false"
kv_soft_delete_retention_days    = 7
kv_public_network_access_enabled = false

// LaW
law_internet_ingestion_enabled = false