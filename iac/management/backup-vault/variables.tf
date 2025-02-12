# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
  })
}

variable "soft_delete" {
  type = string
  description = "The soft delete setting for the backup vault"
}