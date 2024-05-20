# Init command
# gcloud auth login
# gcloud config set project mashanz-software-engineering
# terraform init

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project_id
  region = var.region
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "gke_${var.project_id}_${var.region}-${var.cluster}"
}

# https://registry.terraform.io/providers/hashicorp/vault/latest
provider "vault" {
  address = var.vault_url
}

# https://registry.terraform.io/providers/oboukili/argocd/latest/
provider "argocd" {
  server_addr = "argocd.bootcamp.onxp.net:443"
  username    = "admin"
  password    = "6KGojhKP6Rbnxw9x"
}

# https://terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "onxp-terraform"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.14.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.26.0"
    }

    vault = {
      source = "hashicorp/vault"
      version = "3.25.0"
    }

    argocd = {
      source = "oboukili/argocd"
      version = "6.1.1"
    }
  }
}