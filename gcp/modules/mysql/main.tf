# creds from vault
data "vault_kv_secret_v2" "vault-onxp-mysql" {
  name = "gpc/mysql"
  mount = "kv"
}

resource "google_sql_database" "onxp-mysql-production" {
  name = "onxp-mysql-production"
  instance = google_sql_database_instance.onxp-mysql.name
}

# Another example using MySQL in module
resource "google_sql_database_instance" "onxp-mysql" {
  name = "onxp-mysql"
  region = var.region
  database_version = var.mysql_version

  settings {
    tier = "db-f1-micro"
    availability_type = "ZONAL"
    disk_autoresize = true
    disk_size = var.size
    disk_type = "PD_SSD"

    backup_configuration {
      enabled = true
      location = var.region
      transaction_log_retention_days = var.backup_retention
      binary_log_enabled = true

      backup_retention_settings {
        retained_backups = var.backup_retention
      }
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.network_id
      authorized_networks {
        name = "default"
        value = "0.0.0.0/0"
      }
    }

    insights_config {
      query_insights_enabled = true
    }
    
    location_preference {
      zone = "${var.region}-a"
    }

    database_flags {
      name = "max_connections"
      value = 1000
    }

    maintenance_window {
      day  = var.backup_retention
      hour = var.backup_retention
    }
  }

  deletion_protection  = "true"
}

resource "google_sql_database_instance" "onxp-mysql-replica" {
  name = "onxp-mysql-replica"
  region = var.region
  database_version = var.mysql_version
  master_instance_name = google_sql_database_instance.onxp-mysql.name

  settings {
    tier = "db-f1-small"
    availability_type = "ZONAL"
    disk_autoresize = true
    disk_size = var.size
    disk_type = "PD_SSD"

    backup_configuration {
      enabled = false
      transaction_log_retention_days = var.backup_retention

      backup_retention_settings {
        retained_backups = var.backup_retention
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    insights_config {
      query_insights_enabled = true
    }

    location_preference {
      zone = "${var.region}-a"
    }

    database_flags {
      name = "max_connections"
      value = 1000
    }
  }

  deletion_protection  = "true"
}