data "azurerm_kubernetes_cluster" "reactapp" {
  name = azurerm_kubernetes_cluster.reactapp.name
  resource_group_name = azurerm_resource_group.reactapp.name
}

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
  principal_id                    = data.azurerm_kubernetes_cluster.reactapp.kubelet_identity[0].object_id
}

provider "kubernetes" {
  load_config_file = false
  host = data.azurerm_kubernetes_cluster.reactapp.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.reactapp.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.reactapp.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.reactapp.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_deployment" "reactapp" {
  metadata {
    name = "reactapp-${var.ARM_ENV}"
    labels = {
      App = "Reactapp"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "Reactapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "Reactapp"
        }
      }
      spec {
        container {
          image = "${var.ARM_ACR}.azurecr.io/${var.ARM_REPOSITORY}-${var.ARM_ENV}:${var.build_tag}"
          name  = "reactapp-${var.ARM_ENV}"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "reactapp" {
  metadata {
    name = "reactapp-${var.ARM_ENV}"
  }
  spec {
    selector = {
      App = kubernetes_deployment.reactapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.reactapp.status.0.load_balancer.0.ingress.0.ip
}