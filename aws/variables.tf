variable "region" {
  description = "Region of project"
  type = string
  default = "us-east-1"
}

variable "zone" {
  description = "Zone of project"
  type = string
  default = "us-east-1a"
}

variable "cluster_name" {
  description = "K8s Cluster name"
  type = string
  default = "onxp-k8s"
}
