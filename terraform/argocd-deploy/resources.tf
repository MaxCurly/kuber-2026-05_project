resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "10.9.1" # Для этого чарта используется global.image
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  timeout          = 600

  values = [
    yamlencode({
      global = {
        image = {
          repository = "cr.yandex/cn1vj9hg7fv2jlquf8hj/argoproj/argocd"
        }
      }
    })
  ]
}

resource "kubectl_manifest" "root_app" {
  depends_on = [helm_release.argocd]

  yaml_body = <<-YAML
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    metadata:
      name: root-app
      namespace: argocd
      finalizers:
        - resources-finalizer.argocd.argoproj.io
    spec:
      project: default
      source:
        repoURL: 'https://github.com/MaxCurly/kuber-2026-05_project.git'
        targetRevision: HEAD
        path: argocd/
        directory:
          recurse: true
      destination:
        server: 'https://kubernetes.default.svc'
        namespace: argocd
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
  YAML
}
