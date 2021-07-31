data "azurerm_kubernetes_cluster" "reactapp" {
  name = azurerm_kubernetes_cluster.reactapp.name
}

data "azurerm_resource_group" "reactapp" {
  name = azurerm_resource_group.reactapp.name
}

provider "kubernetes" {
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
    replicas = 2
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
          image = "${var.ARM_ACR}.azurecr.io/${var.ARM_REPOSITORY}-${var.ARM_ENV}:${var.ARM_BUILD_TAG}"
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