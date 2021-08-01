data "azuread_service_principal" "aks_sp" {
  application_id = var.ARM_SP_ID
}

output "aks_sp" {
  value = "${data.azurerm_azuread_service_principal.aks_sp.id}"
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
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_sp.object_id
  skip_service_principal_aad_check = true
}