resource "argocd_repository" "csp-k8s-exercise" {
  repo = "git@github.com:onxpnet/k8s-exercise.git"
  username = "git"
  name = "k8s-exercise"
  ssh_private_key = base64decode("<base 64 ssh keys>")
  insecure = true
}

resource "argocd_application" "helm-redis-production" {
  metadata {
    name      = "redis-production"
    namespace = "argocd" # namespace of argocd installation
  }

  spec {
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "exercise-production"
    }

    source {
      repo_url        = "https://charts.bitnami.com/bitnami"
      chart           = "redis"
      target_revision = "19.0.1"
      helm {
        release_name = "redis"
        parameter {
          name  = "image.tag"
          value = "7.2.4-debian-12-r9"
        }
        parameter {
          name  = "auth.enabled"
          value = "false"
        }
        values = <<-VALUES
          architecture: standalone
          master:
            persistence:
              enabled: false
              usePassword: false
        VALUES
      }
    }
  }
}