
resource "google_service_account" "onxp-bootcamp-k8s-sa" {
  account_id   = "onxp-bootcamp-k8s-sa"
  display_name = "OnXP K8s Service Account"
}

# create kubernetes master -> VPC Google
resource "google_container_cluster" "onxp-bootcamp-cluster" {
  name     = "onxp-bootcamp-cluster"
  location = "${var.region}-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.onxp-bootcamp-vpc.self_link
  subnetwork = google_compute_subnetwork.onxp-bootcamp-subnet.self_link
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
    # pods/container di dalam VM instance (cluster)
    cluster_secondary_range_name = google_compute_subnetwork.onxp-bootcamp-subnet.secondary_ip_range[0].range_name
    # services
    services_secondary_range_name = google_compute_subnetwork.onxp-bootcamp-subnet.secondary_ip_range[1].range_name
  }

  private_cluster_config {
    enable_private_nodes = true
    # manage k8s from local
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.24.0.0/28"
  }

  deletion_protection  = "false"
}


resource "google_container_node_pool" "onxp-bootcamp-node-pool" {
  name       = "onxp-bootcamp-node-pool"
  location   = "${var.region}-a"
  cluster    = google_container_cluster.onxp-bootcamp-cluster.name
  node_count = 2

  management {
    auto_repair = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 3
    location_policy = "BALANCED"
  }

  node_locations = [
    "${var.region}-a"
  ]

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    disk_size_gb = 30
    disk_type    = "pd-standard"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.onxp-bootcamp-k8s-sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# resource "google_container_node_pool" "secondary-node-pool" {
#   name       = "secondary-node-pool"
#   location   = "${var.region}-a"
#   cluster    = google_container_cluster.onxp-bootcamp-cluster.name
#   node_count = 2

#   management {
#     auto_repair = true
#     auto_upgrade = true
#   }

#   autoscaling {
#     min_node_count = 2
#     max_node_count = 3
#     location_policy = "BALANCED"
#   }

#   node_locations = [
#     "${var.region}-a"
#   ]

#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"
#     disk_size_gb = 30
#     disk_type    = "pd-standard"

#     labels = {
#       operation = "onxp-alt-pool"
#     }

#     # using taints
#     # taint {
#     #   operation-taints = "alt-taints"
#     #   value  = "true"
#     #   effect = "NO_SCHEDULE"
#     # }
    

#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = google_service_account.onxp-bootcamp-k8s-sa.email
#     oauth_scopes    = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }