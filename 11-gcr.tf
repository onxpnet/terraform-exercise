# GCS

resource "google_service_account" "gcr-onxp-sa" {
  account_id = "gcr-onxp-sa"
}

resource "google_project_iam_member" "gcr-onxp-iam" {
  project = var.project_id
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gcr-onxp-sa.email}"
}

resource "google_project_iam_member" "gcr-onxp-artifact-iam" {
  project = var.project_id
  role = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.gcr-onxp-sa.email}"
}

resource "google_project_iam_member" "gcr-onxp-artifact-uploader-iam" {
  project = var.project_id
  role = "roles/artifactregistry.repoAdmin"
  member = "serviceAccount:${google_service_account.gcr-onxp-sa.email}"
}

resource "google_artifact_registry_repository" "onxp-repo" {
  location      = "us-central1"
  repository_id = "onxp-repo"
  format        = "DOCKER"
}