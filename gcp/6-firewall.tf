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
resource "google_compute_firewall" "nomad-cluster-firewall" {
  name = "nomad-cluster-fn"
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

  target_tags = ["nomad"]
  
  # just example, it's recommended to restrict to specific IP based on needs
  source_ranges = ["0.0.0.0/0"]
}

# setting for swarm cluster
# it's recommended to separate the firewall rules for each needs
resource "google_compute_firewall" "swarm-cluster-firewall" {
  name = "swarm-cluster-fn"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = [ 
      "2377",  # for manager nodes. CLuster management communications
      "7946",  # for all nodes, communication among nodes
      "4789",  # nomad, restricted to cluster's node
      "3000-4000", # for all nodes, port range for services
    ]
  }

  allow {
    protocol = "udp"
    ports = [
      "7946",  # for all nodes, communication among nodes
      "4789",  # nomad, restricted to cluster's node
    ]
  }

  target_tags = ["swarm"]
  
  # just example, it's recommended to restrict to specific IP based on needs
  source_ranges = ["0.0.0.0/0"]
}

# https://docs.rke2.io/install/requirements#inbound-network-rules
# setting for swarm cluster
# it's recommended to separate the firewall rules for each needs
resource "google_compute_firewall" "rke-cluster-firewall" {
  name = "rke-cluster-fn"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports = [ 
      "9345", # RKE2 supervisor API, set on masters, workers -> masters
      "6443", # Kubernetes API, set on masters, workers -> masters
      "10250", # kubelet metrics, set on nodes, nodes -> nodes
      "2379", # etcd client port, set on masters, masters -> masters
      "2380", # etcd peer port, set on masters, masters -> masters
      "2381", # etcd metrics port, set on masters, masters -> masters
      "30000-32767", # NodePort port range, set on nodes, nodes -> nodes
      "4240", # CNI, set on nodes, nodes -> nodes
      "179", # CNI, set on nodes, nodes -> nodes
      "5473", # CNI, set on nodes, nodes -> nodes
      "9098", # CNI, set on nodes, nodes -> nodes
      "9099", # CNI, set on nodes, nodes -> nodes
    ]
  }

  allow {
    protocol = "udp"
    ports = [ 
      "8472", # VXLAN, set on nodes, nodes -> nodes,
      "51820", # VXLAN, set on nodes, nodes -> nodes,
      "51821", # VXLAN, set on nodes, nodes -> nodes,
      "4789", # VXLAN, set on nodes, nodes -> nodes,
    ]
  }

  allow {
    protocol = "icmp"
  }

  target_tags = ["rke"]
  
  # just example, it's recommended to restrict to specific IP based on needs
  source_ranges = ["0.0.0.0/0"]
}
