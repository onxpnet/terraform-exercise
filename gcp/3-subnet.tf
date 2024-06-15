# Subnet
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
# Kubernetes yg punya IP:
# - Node
# - Pods
# - Service

# gcloud: gcloud compute networks subnets create private \
# --network=main \
# --range=10.0.0.0/18 \
# --region=REGION \
# --enable-private-ip-google-access \
# --secondary-range=k8s-pods-ip-range=10.48.0.0/14,k8s-services-ip-range=10.52.0.0/20
resource "google_compute_subnetwork" "private" {
  name = "private"
  # IP untuk Nodes
  ip_cidr_range = "10.0.0.0/18" 
  region = var.region
  network = google_compute_network.main.id
  private_ip_google_access = true
  
  # IP untuk Pods
  secondary_ip_range {
    range_name    = "k8s-pods-ip-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  
  # IP untuk services
  secondary_ip_range {
    range_name    = "k8s-services-ip-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}