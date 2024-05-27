# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "vm_sa" {
  account_id   = "primary-vm-sa"
  display_name = "VM Service Account"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "vm_iam" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "onxp_vm" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/count
  count = 2 # create 2 VMs

  name         = "gke-onxp-vm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"
  
  tags = ["vm", "http-server"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size = 20
      type = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.self_link
    access_config {}
  }
  
  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
  
  metadata = {
    ssh-keys = "${local.gce_user}:${file("./../keys/id_rsa.pub")}"
    serial-port-logging-enable = "TRUE"
  }
  
  deletion_protection = true
  allow_stopping_for_update = true
}

# query the latest image, for latest "hardened" image
data "google_compute_image" "onx_ubuntu_image" {
  family  = var.image_family
  project = var.project_id
}

resource "google_compute_instance" "vm_packer" {
  name         = "vm-packer"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.onx_ubuntu_image.self_link
    }
  }

  network_interface {
    network = "default"
  }
}

# resource "google_compute_instance" "gke-fn5-vm" {
#   name         = "gke-fn5-vm"
#   machine_type = "e2-standard-8"
#   zone         = "${var.region}-a"

#   tags = ["vm", "gke-fn", "ns"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       size = 200
#       type = "pd-balanced"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.private.self_link
#     access_config {}
#   }

#   service_account {
#     email  = google_service_account.vm-sa.email
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     ssh-keys = "${var.gce_user}:${file("./keys/id_rsa.pub")}"
#     serial-port-logging-enable = "TRUE"
#   }

#   deletion_protection = false
#   allow_stopping_for_update = true
# }

# resource "google_compute_instance" "gke-fn6-vm" {
#   name         = "gke-fn6-vm"
#   machine_type = "e2-standard-8"
#   zone         = "${var.region}-a"

#   tags = ["vm", "gke-fn", "ns"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       size = 200
#       type = "pd-balanced"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.private.self_link
#     access_config {}
#   }

#   service_account {
#     email  = google_service_account.vm-sa.email
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     ssh-keys = "${var.gce_user}:${file("./keys/id_rsa.pub")}"
#     serial-port-logging-enable = "TRUE"
#   }

#   deletion_protection = false
#   allow_stopping_for_update = true
# }

# resource "google_compute_instance" "gke-fn7-vm" {
#   name         = "gke-fn7-vm"
#   machine_type = "e2-standard-8"
#   zone         = "${var.region}-a"

#   tags = ["vm", "gke-fn", "ns"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       size = 200
#       type = "pd-balanced"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.private.self_link
#     access_config {}
#   }

#   service_account {
#     email  = google_service_account.vm-sa.email
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     ssh-keys = "${var.gce_user}:${file("./keys/id_rsa.pub")}"
#     serial-port-logging-enable = "TRUE"
#   }

#   deletion_protection = false
#   allow_stopping_for_update = true
# }

# using local values
locals {
  gce_user = "glendmaatita_me"
}