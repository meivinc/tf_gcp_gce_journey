# /******************************************
#   DNS Forwarding 
# *****************************************/

resource "google_dns_managed_zone" "private_zone" {
  name        = "private-google-api"
  dns_name    = "googleapis.com."
  description = "Private DNS to Google API"
  project     = local.project_init_id

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = module.vpc_network.network.id
    }
  }
}

resource "google_dns_record_set" "private_google" {
  name    = "private.${google_dns_managed_zone.private_zone.dns_name}"
  type    = "A"
  ttl     = 300
  project = local.project_init_id

  managed_zone = google_dns_managed_zone.private_zone.name

  rrdatas = [
    "199.36.153.10",
    "199.36.153.11",
    "199.36.153.8",
    "199.36.153.9",
  ]
}

resource "google_dns_record_set" "public_cname" {
  name         = "*.${google_dns_managed_zone.private_zone.dns_name}"
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["private.${google_dns_managed_zone.private_zone.dns_name}"]
  project      = local.project_init_id

}