# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic
resource "google_pubsub_topic" "onxp-pubsub" {
  name = "onxp-pubsub-example"
  message_retention_duration = "172800s"

  message_storage_policy {
    allowed_persistence_regions = [
      var.region,
    ]
  }

  labels = {
    name = "onxp"
  }

  depends_on = [google_pubsub_schema.onxp-pubsub-schema]
  schema_settings {
    schema = "projects/${var.project_id}/schemas/${google_pubsub_schema.onxp-pubsub-schema.name}"
    encoding = "JSON"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription
resource "google_pubsub_subscription" "onxp-subscription" {
  name  = "onxp-subscription"
  topic = google_pubsub_topic.onxp-pubsub.name

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = "https://pubsub.onxp.net/push-agent"
  }

  message_retention_duration = "259200s"
  retain_acked_messages = true

  expiration_policy {
    ttl = "432000s"
  }

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_schema
resource "google_pubsub_schema" "onxp-pubsub-schema" {
  name = "onxp-pubsub-schema"
  type = "AVRO"
  definition = "{\"type\": \"record\",\"name\": \"ticket\",\"fields\": [{\"name\": \"channelId\",\"type\": \"int\"},{\"name\": \"customerId\",\"type\": \"int\"},{\"name\": \"topicId\",\"type\": \"int\"}]}"
  project = var.project_id
}

# service account
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "pubsub-sa" {
  account_id = "pubsub-sa"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "iam-pubsub" {
  project = var.project_id
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:${google_service_account.pubsub-sa.email}"
}
