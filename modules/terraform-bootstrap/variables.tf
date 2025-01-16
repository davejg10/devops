# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
    identifier  = optional(string)
  })
}

variable "app_config" {
  type = map(object({
    state_container_name = string
    rg_name = string
    identity_name = string
  }))
}

variable "github_repository_name" {
  type = string
}

variable "github_organisation_target" {
  type = string
}

variable "github_environment" {
  type = string
}