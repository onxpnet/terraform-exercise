# NAT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "onxp-nat" {
  name   = "onxp-nat"
  router = google_compute_router.onxp-router.name
  region = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  nat_ips = [ google_compute_address.onxp-nat-address.self_link ]
  
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}



# Reserve Static IP Address for NAT
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "onxp-nat-address" {
  name = "onxp-nat-address"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [ google_project_service.compute ]
}