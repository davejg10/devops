# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
    identifier  = string
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

// Self-hosted-runners
variable "github_organization" {
  type = string
  default = "davejg10"
}
variable "project" {
  type = string
  default = "devops-runners"
}
variable "github_app_key_secret_name" {
  type = string
}
// The rest are all passed in via cmdline
variable "github_app_id" {
  type = string
  default = "test"
}

variable "github_installation_id" {
  type = string
}
variable "github_app_key" {
  type = string
  sensitive   = true
}
