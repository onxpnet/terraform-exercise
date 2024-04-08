# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_disk
resource "google_compute_disk" "onxp-exercise-storage" {
  name  = "onxp-exercise-storage"
  zone  = "${var.region}-a"

  size = 10
  physical_block_size_bytes = 4096
}

resource "google_compute_disk" "onxp-atlantis-storage" {
  name  = "onxp-atlantis-storage"
  zone  = "${var.region}-a"

  size = 10
  physical_block_size_bytes = 4096
}