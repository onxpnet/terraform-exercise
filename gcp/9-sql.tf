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

  # if using vault
  # name = data.vault_kv_secret_v2.vault-onxp-clousql.data["username"]
  # password = data.vault_kv_secret_v2.vault-onxp-clousql.data["password"]
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

# manual:
# ~$ gcloud iam service-accounts add-iam-policy-binding \
#   --role roles/iam.workloadIdentityUser \
#   --member "serviceAccount:mashanz-software-engineering.svc.id.goog[exercise/onxp-exercise-sa]" \
#   cloudsql-onxp-sa@mashanz-software-engineering.iam.gserviceaccount.com
# 
# Annotate the KSA to tie it with GSA
# ~$ kubectl annotate serviceaccount \
#   --namespace exercise \
#   onxp-exercise-sa \
#   iam.gke.io/gcp-service-account=cloudsql-onxp-sa@mashanz-software-engineering.iam.gserviceaccount.com
resource "google_service_account_iam_binding" "cloudsql-onxp-workload-identity" {
  service_account_id = google_service_account.cloudsql-onxp.id
  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[exercise/onxp-exercise-sa]",
  ]
}

# creds from vault
data "vault_kv_secret_v2" "vault-onxp-clousql" {
  name = "gpc/cloudsql"
  mount = "kv"
}

# using modules for MySQL

# MySQL Instance
module "mysql" {
  source = "./modules/mysql"
  region = var.region
  mysql_version = "MYSQL_8_0"
  size = 20
  backup_retention = 7
  network_id = google_compute_network.main.id

  depends_on = [ google_service_networking_connection.private_vpc_connection_support ]
}

# MySQL User
module "mysql_user" {
  source = "./modules/mysql_user"
  mysql_instance_name = module.mysql.mysql_database_instance
}