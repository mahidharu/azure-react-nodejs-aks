/*data "azuread_service_principal" "aks_sp" {
  application_id = var.ARM_CLIENT_ID
}*/

/*resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}images"
  resource_group_name      = azurerm_resource_group.reactapp.name
  location                 = azurerm_resource_group.reactapp.location
  sku                      = "Basic"
  admin_enabled            = false
}*/

data "azurerm_container_registry" "acr" {
  name                = var.ARM_ACR
  resource_group_name = "images"
}

/*resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "acrpull"
  principal_id                     = data.azuread_service_principal.aks_sp.object_id
  #skip_service_principal_aad_check = true
}*/

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}

output "account_id" {
  value = data.azurerm_client_config.current.client_id
}

resource "azurerm_role_definition" "acrpull" {
  role_definition_id = "00000000-0000-0000-0000-000000000000"
  name               = "acrpull-role-definition"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

resource "azurerm_role_assignment" "acrpull" {
  name               = "00000000-0000-0000-0000-000000000000"
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = azurerm_role_definition.acrpull.role_definition_resource_id
  principal_id       = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "ACRPull"
  #principal_id                     = data.azuread_service_principal.aks_sp.object_id
  principal_id         = azurerm_kubernetes_cluster.reactapp.kubelet_identity[0].object_id
  #skip_service_principal_aad_check = true
}