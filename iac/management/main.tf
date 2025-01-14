terraform {
  backend "azurerm" {
    key      = "management.tfstate"
    resource_group_name = "rg-glb-uks-management"
    storage_account_name = "stglbuksmanagement"
    container_name = "management"
  }
}

terraform {
  required_version = ">= 1.3.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.14.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "core"
  subscription_id                 = "fd1f9c42-234f-4f5a-b49c-04bcfb79351d"

  features {}
}

provider "github" {
  token = var.github_pat_token
  owner = var.github_organisation_target
}

data "azurerm_client_config" "current" {}

