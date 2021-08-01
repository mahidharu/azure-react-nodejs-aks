resource "azurerm_resource_group" "reactapp" {
  name     = "${var.prefix}-rg-${var.ARM_ENV}"
  location = var.location
}