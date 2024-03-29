# GCS

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "vault-bucket" {
  name = "onxp-vault-bucket"
  location = "US-CENTRAL1"
  storage_class = "STANDARD"

  uniform_bucket_level_access = false

  lifecycle_rule {
    condition {
      days_since_noncurrent_time = 7
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
      with_state = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }
  
  versioning {
    enabled = true
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "vault-bucket-sa" {
  account_id = "vault-bucket-sa"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "vault-bucket-im" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.vault-bucket-sa.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_acl
resource "google_storage_bucket_acl" "vault-bucket-acl" {
  bucket = google_storage_bucket.vault-bucket.name

  role_entity = [
    "OWNER:user-${google_service_account.vault-bucket-sa.email}"
  ]
}

# create secret from bucket sa
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key
resource "google_service_account_key" "vault-bucket-sa-key" {
  service_account_id = google_service_account.vault-bucket-sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}
