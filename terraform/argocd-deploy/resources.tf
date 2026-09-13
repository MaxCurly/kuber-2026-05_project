resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.6.0"
  namespace        = argocd
  create_namespace = true
  wait             = true
  timeout          = 600
}