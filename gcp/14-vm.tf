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

# using local values
locals {
  gce_user = "glendmaatita_me"
}