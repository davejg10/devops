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
