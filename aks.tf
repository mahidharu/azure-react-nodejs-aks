resource "azurerm_kubernetes_cluster" "reactapp" {
  name                = "${var.prefix}-k8s-${var.ARM_ENV}"
  location            = "azurerm_resource_group.${var.prefix}.location"
  resource_group_name = "azurerm_resource_group.${var.prefix}.name"
  dns_prefix          = "${var.ARM_ENV}-${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  /*service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }*/

  tags = {
    environment = var.ARM_ENV
  }
}