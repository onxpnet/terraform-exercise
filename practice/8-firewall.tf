
# resource "google_compute_firewall" "fw-onxp-vm" {
#   name    = "allow-ssh"
#   network = google_compute_network.onxp-bootcamp-vpc.name

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80", "443"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }
