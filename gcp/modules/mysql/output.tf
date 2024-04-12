# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/sql_database_instance
output "mysql_database_instance" {
    value = google_sql_database_instance.onxp-mysql.name
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/sql_database
output "mysql_database_onxp_production" {
    value = google_sql_database.onxp-mysql-production.name
}