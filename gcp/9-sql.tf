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

# Another example using MySQL
# resource "google_sql_database_instance" "onxp-mysql" {
#   name = "onxp-mysql"
#   region = var.region
#   database_version = "MYSQL_8_0"

#   depends_on = [google_service_networking_connection.private_vpc_connection_support]

#   settings {
#     tier = "db-f1-micro"
#     availability_type = "ZONAL"
#     disk_autoresize = true
#     # disk_size = 20
#     disk_type = "PD_SSD"

#     backup_configuration {
#       enabled = true
#       location = var.region
#       transaction_log_retention_days = 7
#       binary_log_enabled = true

#       backup_retention_settings {
#         retained_backups = 7
#       }
#     }

#     ip_configuration {
#       ipv4_enabled    = true
#       private_network = google_compute_network.main.id
#       authorized_networks {
#         name = "default"
#         value = "0.0.0.0/0"
#       }
#     }

#     insights_config {
#       query_insights_enabled = true
#     }
    
#     location_preference {
#       zone = "${var.region}-a"
#     }

#     database_flags {
#       name = "max_connections"
#       value = 1000
#     }

#     maintenance_window {
#       day  = 7
#       hour = 7
#     }
#   }

#   deletion_protection  = "true"
# }

# resource "google_sql_database_instance" "onxp-mysql-replica" {
#   name = "onxp-mysql-replica"
#   region = var.region
#   database_version = "MYSQL_8_0"
#   master_instance_name = google_sql_database_instance.onxp-mysql.name

#   depends_on = [google_service_networking_connection.private_vpc_connection_support]

#   settings {
#     tier = "db-f1-small"
#     availability_type = "ZONAL"
#     disk_autoresize = true
#     # disk_size = 20
#     disk_type = "PD_SSD"

#     backup_configuration {
#       enabled = false
#       transaction_log_retention_days = 7

#       backup_retention_settings {
#         retained_backups = 7
#       }
#     }

#     ip_configuration {
#       ipv4_enabled    = false
#       private_network = google_compute_network.main.id
#     }

#     insights_config {
#       query_insights_enabled = true
#     }

#     location_preference {
#       zone = "${var.region}-a"
#     }

#     database_flags {
#       name = "max_connections"
#       value = 1000
#     }
#   }

#   deletion_protection  = "true"
# }

# resource "google_sql_user" "onxp-mysql" {
#   instance = google_sql_database_instance.onxp-mysql.name
#   name = data.vault_kv_secret_v2.vault-onxp-clousql.data["mysql_username"]
#   password = data.vault_kv_secret_v2.vault-onxp-clousql.data["mysql_password"]
# }

# # Used by proxysql
# resource "google_sql_user" "monitoring-onxp-mysql" {
#   instance = google_sql_database_instance.onxp-mysql.name
#   name = data.vault_kv_secret_v2.vault-onxp-clousql.data["mysql_monitoring_username"]
#   password = data.vault_kv_secret_v2.vault-onxp-clousql.data["mysql_monitoring_password"]
# }