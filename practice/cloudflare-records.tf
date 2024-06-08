# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
resource "cloudflare_record" "ansible-onxp-cf" {
  zone_id = var.cloudflare_zone_id
  name = "ansible.bootcamp"
  value = google_compute_instance.ansible-onxp-vm.network_interface[0].access_config[0].nat_ip
  type = "A"
  ttl = 3600
}