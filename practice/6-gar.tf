# GCS

resource "google_service_account" "gar-onxp-sa" {
  account_id = "gar-onxp-sa"
}

resource "google_project_iam_member" "gar-onxp-iam" {
  project = var.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gar-onxp-sa.email}"
}

resource "google_project_iam_member" "gar-onxp-artifact-iam" {
  project = var.project_id
  role = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.gar-onxp-sa.email}"
}

resource "google_project_iam_member" "gar-onxp-artifact-uploader-iam" {
  project = var.project_id
  role = "roles/artifactregistry.repoAdmin"
  member = "serviceAccount:${google_service_account.gar-onxp-sa.email}"
}

resource "google_artifact_registry_repository" "onxp-bootcamp-repo" {
  location      = "us-central1"
  repository_id = "onxp-bootcamp-repo"
  format        = "DOCKER"
}