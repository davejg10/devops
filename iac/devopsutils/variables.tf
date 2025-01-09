# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
  })
}

// Networking
variable "vnet_address_space" {
  type = string
}

// Azure Container Registry
variable "acr_sku" {
  type = string
}

variable "acr_zone_redundancy_enabled" {
  type = bool
}

// Key Vault
variable "key_vault_sku_name" {
  type = string
}

variable "kv_purge_protection_enabled" {
  type = string
}

variable "kv_soft_delete_retention_days" {
  type = number
}

variable "kv_public_network_access_enabled" {
  type = bool
}