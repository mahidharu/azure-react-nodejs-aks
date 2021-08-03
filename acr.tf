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

/*data "azurerm_user_assigned_identity" "agentpool_identity" {
  name                = "${azurerm_kubernetes_cluster.reactapp.name}-agentpool"
  resource_group_name = azurerm_kubernetes_cluster.reactapp.node_resource_group
  depends_on          = [azurerm_kubernetes_cluster.reactapp]
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                    = data.azurerm_user_assigned_identity.agentpool_identity.principal_id
  #skip_service_principal_aad_check = true
}*/