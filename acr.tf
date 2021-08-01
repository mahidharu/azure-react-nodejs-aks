data "azuread_service_principal" "aks_principal" {
  application_id = var.ARM_CLIENT_ID
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}-images"
  resource_group_name      = azurerm_resource_group.reactapp.name
  location                 = azurerm_resource_group.reactapp.location
  sku                      = "Basic"
  admin_enabled            = false
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.aks_principal.id
  skip_service_principal_aad_check = true
}