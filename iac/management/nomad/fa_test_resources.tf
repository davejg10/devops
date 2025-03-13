# These resources are used to test the data-services locally.
# Allow us to use a Service Bus without contaminating the Dev one.
resource "azurerm_resource_group" "test_resources" {
  count = var.environment_settings.environment == "dev" ? 1 : 0

  name     = "rg-sandbox-uks-resources"
  location = var.environment_settings.region
}

resource "azurerm_servicebus_namespace" "nomad" {
  count = var.environment_settings.environment == "dev" ? 1 : 0

  name                = "sbns-sandbox-uks-resources"
  resource_group_name = azurerm_resource_group.test_resources[0].name
  location            = var.environment_settings.region
  sku                 = "Standard"

  local_auth_enabled = true
  // Service bus is public as Service Endpoints/Private Endpoints is a premium feature
  // Premium costs 70p per hour!
  public_network_access_enabled = true
}

resource "azurerm_servicebus_queue" "pre_processed" {
  count = var.environment_settings.environment == "dev" ? 1 : 0

  name         = "nomad_pre_processed"
  namespace_id = azurerm_servicebus_namespace.nomad[0].id
}

resource "azurerm_servicebus_queue" "processed" {
  count = var.environment_settings.environment == "dev" ? 1 : 0

  name         = "nomad_processed"
  namespace_id = azurerm_servicebus_namespace.nomad[0].id
}

resource "azurerm_role_assignment" "servicebus_sender" {
  scope                = azurerm_servicebus_namespace.nomad[0].id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = data.azurerm_client_config.current.object_id
}
resource "azurerm_role_assignment" "servicebus_receiver" {
  scope                = azurerm_servicebus_namespace.nomad[0].id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = data.azurerm_client_config.current.object_id
}