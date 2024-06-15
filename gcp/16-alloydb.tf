# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster
resource "google_alloydb_cluster" "onxp-alloydb-cluster" {
  cluster_id = "onxp-alloydb-cluster"
  location   = var.region

  network_config {
    network = google_compute_network.main.id
  }
  
  initial_user {
    user     = data.vault_kv_secret_v2.vault-onxp.data["ALLOYDB_USERNAME"]
    password = data.vault_kv_secret_v2.vault-onxp.data["ALLOYDB_PASSWORD"]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance
# PRIMARY DB
resource "google_alloydb_instance" "onxp-alloydb-primary" {
  cluster       = google_alloydb_cluster.alloydb-cluster.name
  instance_id   = "onxp-alloydb-primary"
  instance_type = "PRIMARY"

  depends_on = [google_service_networking_connection.private_vpc_connection_support]

  machine_config {
    cpu_count = 2
  }
}

# Read replica
resource "google_alloydb_instance" "onxp-alloydb-read" {
  cluster       = google_alloydb_cluster.alloydb-cluster.name
  instance_id   = "onxp-alloydb-read"
  instance_type = "READ_POOL"

  depends_on = [google_service_networking_connection.private_vpc_connection_support]

  machine_config {
    cpu_count = 2
  }

  read_pool_config {
    node_count = 1
  }
}