data "azuread_service_principal" "aks_sp" {
  application_id = var.ARM_CLIENT_ID
  app_role_assignment_required = false
}

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

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "acrpull"
  principal_id                     = data.azuread_service_principal.aks_sp.object_id
  #skip_service_principal_aad_check = true
}