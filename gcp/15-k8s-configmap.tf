# vault
data "vault_kv_secret_v2" "vault-onxp" {
  name = "gpc/credentials"
  mount = "kv"
}

//
resource "kubernetes_config_map" "atlantis-onxp-config" {
  metadata {
    name = "atlantis-onxp-config"
    namespace = kubernetes_namespace.vault.id
  }

  data = {
    ATLANTIS_ALLOW_COMMANDS = "version,plan,apply,unlock"
    ATLANTIS_ALLOW_FORK_PRS = "true"
    ATLANTIS_API_SECRET = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_API_SECRET"]
    ATLANTIS_ATLANTIS_URL = "https://atlantis.ops.onxp.net"
    ATLANTIS_GH_TOKEN = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_GH_TOKEN"]
    ATLANTIS_GH_USER = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_GH_USER"]
    ATLANTIS_GH_WEBHOOK_SECRET = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_GH_WEBHOOK_SECRET"]
    ATLANTIS_REDIS_HOST = "redis-master"
    ATLANTIS_REPO_ALLOWLIST = "github.com/onxp/terraform-exercise"
    ATLANTIS_WEB_BASIC_AUTH = "true"
    ATLANTIS_WEB_USERNAME = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_WEB_USERNAME"]
    ATLANTIS_WEB_PASSWORD = data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_WEB_PASSWORD"]
    ATLANTIS_PORT = "4141"
    ATLANTIS_DATA_DIR = "/app/atlantis"
    VAULT_TOKEN = data.vault_kv_secret_v2.vault-onxp.data["VAULT_TOKEN"]
    GOOGLE_APPLICATION_CREDENTIALS = "/app/google.json"
  }
}

resource "kubernetes_config_map" "atlantis-onxp-gcp-config" {
  metadata {
    name = "atlantis-onxp-gcp-config"
    namespace = kubernetes_namespace.atlantis.id
  }

  data = {
    "google.json" = base64decode(google_service_account_key.atlantis-onxp-sa-key.private_key)
  }
}

resource "kubernetes_config_map" "atlantis-kube-config" {
  metadata {
    name = "atlantis-kube-config"
    namespace = kubernetes_namespace.atlantis.id
  }

  data = {
    "config" = base64decode(data.vault_kv_secret_v2.vault-onxp.data["ATLANTIS_KUBECONFIG"])
  }
}