# Kubernetes
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "onxp-kubernetes" {
  name               = "onxp-kubernetes"
  location           = "${var.region}-a"
  initial_node_count = 1
  remove_default_node_pool = true
  network = google_compute_network.main.self_link
  subnetwork = google_compute_subnetwork.private.self_link
  logging_service = "none"
  monitoring_service = "none"
  networking_mode = "VPC_NATIVE"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = google_compute_subnetwork.private.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.private.secondary_ip_range[1].range_name
  }

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.24.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}