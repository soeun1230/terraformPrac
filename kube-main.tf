# kube-main.tf

# Kubernetes 클러스터에 접근하기 위한 데이터 소스
data "azurerm_kubernetes_cluster" "kubernetes" {
  name                = var.aks_name
  resource_group_name = var.resource_group_name
}

# Backend Deployment
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = "${var.acr_name}.azurecr.io/backend:latest"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# Frontend Deployment
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          name  = "frontend"
          image = "${var.acr_name}.azurecr.io/frontend:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Backend 및 Frontend 서비스 정의
resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "frontend"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "backend_service" {
  metadata {
    name      = "backend-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 5000
      target_port = 5000
    }

    type = "ClusterIP"
  }
}

# Ingress 설정
resource "kubernetes_manifest" "ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "ingress"
      namespace = "default"
      annotations = {
        "kubernetes.io/ingress.class" = "nginx"
      }
    }
    spec = {
      rules = [
        {
          host = "*"
          http = {
            paths = [
              {
                path     = "/api"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = kubernetes_service.backend_service.metadata[0].name
                    port = {
                      number = 5000
                    }
                  }
                }
              },
              {
                path     = "/"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = kubernetes_service.frontend_service.metadata[0].name
                    port = {
                      number = 80
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }
}
