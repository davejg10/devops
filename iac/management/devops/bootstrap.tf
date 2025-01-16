locals {
  github_repository_name     = "devops"
  github_organisation_target = "davejg10"
  github_environment         = var.environment_settings.environment

  app_config = {
    devopsutils = {
      state_container_name = "devopsutils"
      rg_name              = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-devopsutils"
      identity_name        = "devops"
    }
    ghrunners = {
      state_container_name = "ghrunners"
      rg_name              = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-ghrunners"
      identity_name        = "devops"
    }
  }
}

module "terraform_bootstrap" {
  source = "../../../modules/terraform-bootstrap"

  environment_settings       = var.environment_settings
  app_config                 = local.app_config
  github_repository_name     = local.github_repository_name
  github_environment         = local.github_environment
  github_organisation_target = local.github_organisation_target
}

output "terraform_client_ids" {
  value = module.terraform_bootstrap.terraform_client_ids
}