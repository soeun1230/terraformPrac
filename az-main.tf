# az-main.tf
# data -> 기존 리소스 가져오기 

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "aks_id" {
  value = data.azurerm_kubernetes_cluster.aks.id
}

output "acr_id" {
  value = data.azurerm_container_registry.acr.id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.aks_acr_pull.id
}