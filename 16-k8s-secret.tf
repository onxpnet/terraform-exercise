# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service_account
resource "kubernetes_secret" "vault-config-secret" {
  metadata {
    name = "vault-config"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  data = {
    "vault-sa.json" = base64decode(google_service_account_key.atlantis-onxp-sa-key.private_key)
  }
}