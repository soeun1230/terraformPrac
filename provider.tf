terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.70.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"  # 최신 버전으로 맞춰줘
    }
  }
}

provider "azurerm" {
  features {}
}

# Kubernetes 클러스터 접속 설정
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.kubernetes.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config[0].client_key)
}




# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.kubernetes.kube_config.0.host
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config.0.cluster_ca_certificate)
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config.0.client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.kubernetes.kube_config.0.client_key)
# }