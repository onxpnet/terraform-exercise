# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

resource "kubernetes_namespace" "glitchtip" {
  metadata {
    name = "glitchtip"
  }
}

resource "kubernetes_namespace" "exercise" {
  metadata {
    name = "exercise"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "elastic-system" {
  metadata {
    name = "elastic-system"
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = "kyverno"
  }
}

resource "kubernetes_namespace" "drone" {
  metadata {
    name = "drone"
  }
}