environment_settings = {
  region         = "uksouth"
  region_code    = "uks"
  environment    = "glb"
  app_name       = "ghrunners"
}

// Name of repos you want the ghrunners to be scaled to.
container_app_jobs = {
  "devops" = {
    cpu = 0.25
    memory = "0.5Gi"
  }
  "nomad_infra" = {
    cpu = 0.25
    memory = "0.5Gi"
  }
  "nomad_backend" = {
    cpu = 2  // Building Java apps requires a bit more juice
    memory = "4Gi"
  }
  "nomad_app" = {
    cpu = 0.25
    memory = "0.5Gi"
  }
}
