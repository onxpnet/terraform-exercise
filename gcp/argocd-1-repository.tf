# https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/repository
resource "argocd_repository" "csp-k8s-exercise" {
  repo = "git@github.com:onxpnet/k8s-exercise.git"
  username = "git"
  name = "k8s-exercise"
  ssh_private_key = base64decode(base64decode(data.vault_kv_secret_v2.vault-onxp.data["PRIVATE_SSH_KEY"]))
  insecure = true
}