environment_settings = {
  region         = "uksouth"
  region_code    = "uks"
  environment    = "glb"
  app_name       = "github-runners"
  identifier     = "01"
}

// Networking
vnet_address_space = "11.0.0.0/18"

// Azure Container Registry
acr_sku = "Standard"
acr_zone_redundancy_enabled = false

// Key Vault
key_vault_sku_name = "standard"
kv_purge_protection_enabled = "false"
kv_soft_delete_retention_days = 7
kv_public_network_access_enabled = true

// Azure Container Registry
# acr_sku = "Standard"
# acr_zone_redundancy_enabled = false


// Self-hosted-runners
github_app_key_secret_name = "github-app-key"