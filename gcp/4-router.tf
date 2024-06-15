# Router
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router

# gcloud: gcloud compute routers create onxp-router \
#   --region=REGION \
#   --network=main
resource "google_compute_router" "onxp-router" {
  name = "onxp-router"
  region = var.region
  network = google_compute_network.main.id
}