# Firewall
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

# setting for nomad and consul cluster
# it's recommended to separate the firewall rules for each needs
resource "google_compute_firewall" "allow-ns-firewall" {
  name = "allow-ns-fn"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = [ 
      "4646",  # nomad ui, can be publicly by restricted to specific IP
      "4647",  # nomad, restricted to cluster's node
      "4648",  # nomad, restricted to cluster's node
      "8300",  # consul, restricted to cluster's node
      "8301",  # consul, restricted to cluster's node
      "8302",  # consul, restricted to cluster's node
      "8500",  # consul ui, can be publicly by restricted to specific IP
      "8600",  # consul, restricted to cluster's node
      "9999",  # fabio, restricted to cluster's node
      "9998"   # fabio ui, can be publicly by restricted to specific IP
    ]
  }

  target_tags = ["ns"]
  
  # just example, it's recommended to restrict to specific IP based on needs
  source_ranges = ["0.0.0.0/0"]
}
