# DB Instance
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
resource "google_sql_database_instance" "onxp-sql" {
  name = "onxp-sql"
  region = var.region
  database_version = "POSTGRES_15"

  depends_on = [google_service_networking_connection.private_vpc_connection_support]

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    disk_autoresize = true
    disk_size = 10
    disk_type = "PD_SSD"

    backup_configuration {
      enabled = true
      location = var.region
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      ipv4_enabled = true
      private_network = google_compute_network.main.id

      authorized_networks {
        name = "public"
        value = "0.0.0.0/0"
      }
    }

    # bug?
    deletion_protection_enabled = false
    
    insights_config {
      query_insights_enabled = true
    }
  }

  deletion_protection = false
}

# replica
resource "google_sql_database_instance" "onxp-sql-replica" {
  name = "onxp-sql-replica"
  region = var.region
  database_version = "POSTGRES_15"
  master_instance_name = google_sql_database_instance.onxp-sql.name

  depends_on = [google_service_networking_connection.private_vpc_connection_support]

  settings {
    tier = "db-f1-small"
    availability_type = "ZONAL"
    disk_autoresize = true
    disk_size = 10
    disk_type = "PD_SSD"

    backup_configuration {
      enabled = false
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.main.id
    }

    location_preference {
      zone = "${var.region}-a"
    }

    # bug?
    deletion_protection_enabled = false
    
    insights_config {
      query_insights_enabled = true
    }
  }

  deletion_protection  = "false"
}

# Database
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database

resource "google_sql_database" "onxp-production" {
  name = "onxp-production"
  instance = google_sql_database_instance.onxp-sql.name
}

# Create DB User
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user

resource "google_sql_user" "onxp-user" {
  name = "onxp"
  password = "onxpsecret"
  instance = google_sql_database_instance.onxp-sql.name
}

# [Recommendation] Create Service Account for CloudSQL
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "cloudsql-onxp" {
  account_id = "cloudsql-onxp"
}

# [Recommendation] Add Permission to Service Account
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "cloudsql-onxp-iam" {
  project = var.project_id
  role    = "roles/cloudsql.admin"
  member  = "serviceAccount:${google_service_account.cloudsql-onxp.email}"
}

# set workload identity: attach GSA to KSA
# parameters: k8s namespace and service account
resource "google_service_account_iam_binding" "cloudsql-onxp-workload-identity" {
  service_account_id = google_service_account.cloudsql-onxp.id
  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[exercise/onxp-exercise-sa]",
  ]
}