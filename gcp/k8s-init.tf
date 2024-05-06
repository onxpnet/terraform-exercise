# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "glitchtip" {
  metadata {
    name = "glitchtip"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "exercise" {
  metadata {
    name = "exercise"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "elastic-system" {
  metadata {
    name = "elastic-system"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = "kyverno"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "drone" {
  metadata {
    name = "drone"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "registry" {
  metadata {
    name = "registry"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}

resource "kubernetes_namespace" "argo-rollouts" {
  metadata {
    name = "argo-rollouts"
  }

  depends_on = [
    google_container_cluster.onxp-kubernetes,
    google_container_node_pool.onxp-node-pool
  ]
}
