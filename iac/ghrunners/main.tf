# https://blog.xmi.fr/posts/github-runner-container-app-part1/
terraform {
  backend "azurerm" {
    use_oidc = true
    key      = "github-runner.tfstate"
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
      version = "2.30.0"
    }
  }
}

provider "azurerm" {
  use_oidc                        = true
  resource_provider_registrations = "none"
  subscription_id                 = "73a3c766-6179-4571-acb5-72b4c3b810bb"

  resource_providers_to_register = [
    "Microsoft.App",
  ]

  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {}


data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}"
}