
# https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application
resource "argocd_application" "kustomize-exercise-app-staging" {
  metadata {
    name      = "exercise-app-staging"
    # namespace of argocd installation
    namespace = "argocd"
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "exercise-staging"
    }

    source {
      repo_url = argocd_repository.csp-k8s-exercise.name
      path = "application/kustomize/exercise-app/overlays/staging"
      kustomize {}
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
    }
  }
}