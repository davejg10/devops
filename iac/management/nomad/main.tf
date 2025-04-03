terraform {
  backend "azurerm" {
    resource_group_name  = "rg-glb-uks-management"
    storage_account_name = "stglbuksmanagement"
    container_name       = "management"
  }
}

terraform {
  required_version = ">= 1.3.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.14.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "core"
  subscription_id                 = "73a3c766-6179-4571-acb5-72b4c3b810bb"

  features {}
}

data "azurerm_client_config" "current" {}