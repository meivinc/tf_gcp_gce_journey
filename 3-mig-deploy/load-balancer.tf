locals {
  backend_group_list = [
    module.eu_mig.instance_group,
    module.us_mig.instance_group,
    module.asia_mig.instance_group
]


}

resource "google_compute_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_health_check.autohealing.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  project = local.project_init_id

  dynamic "backend" {
    for_each = local.backend_group_list
    content {
      group = backend.value
      balancing_mode = "UTILIZATION"
      capacity_scaler = 1.0
    }
  }
  
}


resource "google_compute_global_address" "default" {
  name = "l7-xlb-static-ip"
    project = local.project_init_id

  }

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "l7-xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
    project = local.project_init_id

}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "l7-xlb-target-http-proxy"
  url_map  = google_compute_url_map.default.id
    project = local.project_init_id

}

# url map
resource "google_compute_url_map" "default" {
  name            = "l7-xlb-url-map"
  default_service = google_compute_backend_service.default.id
    project = local.project_init_id

}