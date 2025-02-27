# Environment instance specific settings object
variable "environment_settings" {
  type = object({
    region      = string
    region_code = string
    environment = string
    app_name    = string
  })
}

variable "hub_rg_name" {
  type    = string
  default = "rg-glb-uks-devopsutils"
}
variable "hub_vnet_name" {
  type    = string
  default = "vnet-glb-uks-devopsutils"
}
variable "hub_acr_name" {
  type    = string
  default = "acrglbuksdevopsutils"
}
variable "hub_law_name" {
  type    = string
  default = "law-glb-uks-devopsutils"
}