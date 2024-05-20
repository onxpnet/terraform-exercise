resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

# VPC
resource "google_compute_network" "onxp-bootcamp-vpc" {
  project                 = var.project_id
  name                    = "onxp-bootcamp"
  auto_create_subnetworks = false
  mtu                     = 1460
}

# VPC Peering to Google Service
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "private_service_access" {
  name          = "private-service-access"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.onxp-bootcamp-vpc.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
resource "google_service_networking_connection" "private_vpc_connection_support" {
  network                 = google_compute_network.onxp-bootcamp-vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access.name]
}