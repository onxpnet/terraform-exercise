# Router
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router

resource "google_compute_router" "onxp-bootcamp-router" {
  name = "onxp-bootcamp-router"
  region = var.region
  network = google_compute_network.onxp-bootcamp-vpc.id
}