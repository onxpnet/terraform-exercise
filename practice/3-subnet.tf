# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "onxp-bootcamp-subnet" {
  name          = "onxp-bootcamp-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.onxp-bootcamp-vpc.id

  secondary_ip_range {
    range_name    = "k8s-pods-ip-range"
    ip_cidr_range = "10.32.0.0/24"
  }

  secondary_ip_range {
    range_name    = "k8s-services-ip-range"
    ip_cidr_range = "10.48.0.0/24"
  }
}