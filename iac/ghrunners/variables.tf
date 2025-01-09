# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
  })
}

// Self-hosted-runners
variable "github_organization" {
  type    = string
  default = "davejg10"
}
variable "project" {
  type    = string
  default = "devops-runners"
}
variable "github_app_key_secret_name" {
  type = string
}
// The rest are all passed in via cmdline
variable "github_app_id" {
  type    = string
  default = "test"
}

variable "github_installation_id" {
  type = string
}
variable "github_app_key" {
  type      = string
  sensitive = true
}
