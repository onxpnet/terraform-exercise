# Example of creating GCP's service account with admin's previleged 
# in order to be able to run Atlantis: https://www.runatlantis.io/
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "atlantis-onxp-sa" {
  account_id = "atlantis-onxp-sa"
  project = var.project_id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "atlantis-onxp-im" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.atlantis-onxp-sa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "atlantis-onxp-storage-im" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.atlantis-onxp-sa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key
resource "google_service_account_key" "atlantis-onxp-sa-key" {
  service_account_id = google_service_account.atlantis-onxp-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
