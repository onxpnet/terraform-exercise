variable "project_id" {
  description = "Project ID"
  type = string
  default = "mashanz-software-engineering"
}

variable "region" {
  description = "Region of project"
  type = string
  default = "us-central1"
}

variable "cluster" {
  description = "Cluster's name"
  type = string
  default = "onxp-kubernetes"
}

variable "vault_url" {
  description = "Vault's address"
  type = string
  default = "https://vault.ops.onxp.net"
}

variable "image_family" {
  type    = string
  default = "onxp-ubuntu-jammy"
}