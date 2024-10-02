# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
# resource "google_service_account" "onxp_vm_sa" {
#   account_id   = "onxp-vm-sa"
#   display_name = "VM Service Account"
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
# resource "google_project_iam_member" "onxp_vm_iam" {
#   project = var.project_id
#   role    = "roles/container.admin"
#   member  = "serviceAccount:${google_service_account.onxp_vm_sa.email}"
# }

# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
# resource "google_compute_instance" "ansible-onxp-vm" {
#   name         = "my-vm"
#   machine_type = "e2-standard-8"
#   zone         = "${var.region}-a"

#   tags = ["vm", "ansible"]

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2204-lts"
#       size = 80
#       type = "pd-balanced"
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.onxp-bootcamp-subnet.self_link
#     access_config {}
#   }

#   service_account {
#     email  = google_service_account.onxp_vm_sa.email
#     scopes = ["cloud-platform"]
#   }

#   metadata = {
#     ssh-keys = "${local.gce_user}:${file("./../keys/id_rsa.pub")}"
#     serial-port-logging-enable = "TRUE"
#   }

#   deletion_protection = false
#   allow_stopping_for_update = true
# }

# output "ansible-onxp-vm-ip" {
#   value = google_compute_instance.ansible-onxp-vm.network_interface[0].access_config[0].nat_ip
# }

# # using local values
# locals {
#   gce_user = "glendmaatita_me"
# }
