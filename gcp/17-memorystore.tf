# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/redis_instance
resource "google_redis_instance" "onxp-memorystore" {
  name = "onxp-memorystore"
  tier = "STANDARD_HA"
  memory_size_gb = 32
  redis_version = "REDIS_7_2"
  location_id = "${var.region}-a"

#   auth_enabled = true
  redis_configs = {
    "timeout" = "120"
  }

  connect_mode = "PRIVATE_SERVICE_ACCESS"
  depends_on = [google_service_networking_connection.private_vpc_connection_support]

  authorized_network = google_compute_network.main.id
  
}