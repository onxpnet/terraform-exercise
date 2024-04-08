
# https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application
resource "argocd_application" "helm-redis-production" {
  metadata {
    name      = "redis-production"
    # namespace of argocd installation
    namespace = "argocd"
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

        # using parameter
        parameter {
          name  = "image.tag"
          value = "7.2.4-debian-12-r9"
        }
        parameter {
          name  = "auth.enabled"
          value = "false"
        }

        # using values string
        values = <<-VALUES
          architecture: standalone
          master:
            persistence:
              enabled: false
              usePassword: false
        VALUES

        # using values.yaml file
        # value_files = ["/path/to/values.yaml"]
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}