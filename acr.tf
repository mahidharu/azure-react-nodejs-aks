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

output "acr_id" {
  value = data.azurerm_container_registry.acr.id
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                    = azurerm_kubernetes_cluster.reactapp.kubelet_identity[0].object_id
}