# helm-main.tf

# 1. nginx-ingress Controller 배포
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "default"
  repository = "https://charts.helm.sh/stable"
  chart      = "nginx-ingress"
  version    = "1.41.3"
  values     = [
    <<EOF
controller:
  ingressClass: nginx
  service:
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "false"
    type: LoadBalancer
    externalTrafficPolicy: Local
EOF
  ]
}

# 2. ArgoCD 배포
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "default"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.43.0"
  values     = []
}

# 3. MariaDB 배포
resource "helm_release" "mariadb" {
  name       = "mariadb"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  version    = "11.4.2"
  values     = [
    <<EOF
primary:
  persistence:
    enabled: true
    size: 8Gi
EOF
  ]
}

# 4. Kafka 배포
resource "helm_release" "kafka" {
  name       = "kafka"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "31.5.0"
  values     = [
    <<EOF
replicaCount: 1
zookeeper:
  replicaCount: 1
EOF
  ]
}

# 5. Redis 배포
resource "helm_release" "redis" {
  name       = "redis"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "18.3.2"
  values     = [
    <<EOF
replica:
  replicaCount: 1
EOF
  ]
}
