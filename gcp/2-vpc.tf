# VPC

# Enable Google API
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name = "main"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
  mtu = 1460
  delete_default_routes_on_create = false

  # Ref: https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}

# VPC Peering to Google Service
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "private_ip_address_support" {
  name          = "private-ip-address-support"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
resource "google_service_networking_connection" "private_vpc_connection_support" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address_support.name]
}

# Example of creating vpc from remote modules
# https://registry.terraform.io/modules/terraform-google-modules/network/google/latest/submodules/vpc
module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "9.0.0"
  
  project_id   = var.project_id
  network_name = "vpc-modules"
  
  shared_vpc_host = false
}