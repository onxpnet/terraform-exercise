data "vault_kv_secret_v2" "vault-onxp-mysql" {
  name = "gpc/mysql"
  mount = "kv"
}

resource "google_sql_user" "onxp-mysql" {
  instance = var.mysql_instance_name
  name = data.vault_kv_secret_v2.vault-onxp-mysql.data["username"]
  password = data.vault_kv_secret_v2.vault-onxp-mysql.data["password"]
}

# Used by proxysql
resource "google_sql_user" "monitoring-onxp-mysql" {
  instance = var.mysql_instance_name
  name = data.vault_kv_secret_v2.vault-onxp-mysql.data["monitoring_username"]
  password = data.vault_kv_secret_v2.vault-onxp-mysql.data["monitoring_password"]
}