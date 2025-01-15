locals {

  github_repository_name     = "nomad_infra"
  github_organisation_target = "davejg10"
  github_environment         = var.environment_settings.environment

  app_config = {
    nomad_01 = {
      state_container_name = "nomad-backend"
      rg_name              = "rg-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-${var.environment_settings.identifier}"
      identity_name        = "nomadv2"
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