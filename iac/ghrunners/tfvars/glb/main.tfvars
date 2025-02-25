environment_settings = {
  region      = "uksouth"
  region_code = "uks"
  environment = "glb"
  app_name    = "ghrunners"
}

// Name of repos you want the ghrunners to be scaled to.
container_app_jobs = {
  "devops" = {
    cpu    = 0.5
    memory = "1Gi"
  }
  "nomad_infra" = {
    cpu    = 0.5
    memory = "1Gi"
  }
  "nomad_backend" = {
    cpu    = 1 // Building Java apps requires a bit more juice
    memory = "2Gi"
  }
  "nomad_app" = {
    cpu    = 0.25
    memory = "0.5Gi"
  }
}
