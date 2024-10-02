# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "onxp-bootcamp-router" {
  name    = "onxp-bootcamp-router"
  region  = var.region
  network = google_compute_network.onxp-bootcamp-vpc.id
}

# Reserve Static IP Address for NAT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "onxp-nat-address" {
  name = "onxp-nat-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [ google_project_service.compute ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "onxp-bootcamp-nat" {
  name                               = "onxp-bootcamp-nat"
  router                             = google_compute_router.onxp-bootcamp-router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  nat_ips = [ google_compute_address.onxp-nat-address.self_link ]

  subnetwork {
    name = google_compute_subnetwork.onxp-bootcamp-subnet.name
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}
