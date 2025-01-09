# resource "azurerm_container_app" "self_hosted_runners" {
#   name = "ca-${var.environment_settings.environment}-${var.environment_settings.region_code}-${var.environment_settings.app_name}-${var.environment_settings.identifier}"
#   container_app_environment_id = azurerm_container_app_environment.self_hosted_runners.id
#   resource_group_name          = data.azurerm_resource_group.rg.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = "github-runner"
#       image  = "${azurerm_container_registry.devops.login_server}/self-hosted-runners:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"

#       env = {
#         # {
#         #   name = "APP_ID"
#         #   secret = 
#         #   value = var.github_app_id
#         # }
#         # {
#         #   name = "APP_PRIVATE_KEY"
#         #   secret = "github-app-key"
#         # }
#         {
#           name = "RUNNER_SCOPE"
#           secret = "org"
#         }
#         # {}
#       }
#     }
#   }
# }