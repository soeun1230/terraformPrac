variable "resource_group_name" {
  type        = string
  description = "기존에 만든 Azure 리소스 그룹 이름"
}

variable "aks_name" {
  type        = string
  description = "기존에 만든 AKS 클러스터 이름"
}

variable "acr_name" {
  type        = string
  description = "기존에 만든 ACR 이름"
}

variable "location" {
  type        = string
  default     = "koreacentral"
}
