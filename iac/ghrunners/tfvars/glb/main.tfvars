environment_settings = {
  region         = "uksouth"
  region_code    = "uks"
  environment    = "glb"
  app_name       = "ghrunners"
}

// Name of repos you want the ghrunners to be scaled to.
container_app_jobs = ["devops", "nomad_infra", "nomad_backend", "nomad_app"]
