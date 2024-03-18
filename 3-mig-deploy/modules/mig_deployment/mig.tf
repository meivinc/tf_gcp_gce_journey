

resource "google_compute_region_instance_group_manager" "mig_deployment" {

  name  = "${var.mig_prefix}-${var.instance_region}-${var.mig_name}"

  base_instance_name = var.mig_name
  distribution_policy_zones = var.selected_zone
  region = var.instance_region
  version {
    instance_template = var.template_usage
  }


  #   target_pools = [google_compute_target_pool.appserver.id]
  # target_size = var.instance_count

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = var.healthcheck_name
    initial_delay_sec = 300
  }
  project = var.project_id

}


resource "google_compute_region_autoscaler" "mig_autoscaler" {
  name   =  "${var.mig_prefix}-${var.instance_region}-${var.mig_name}-autoscale"
  region = var.instance_region
  target = google_compute_region_instance_group_manager.mig_deployment.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 180

    cpu_utilization {
      target = 0.9
    }
  }
  project = var.project_id

}
# resource "google_compute_target_pool" "appserver" {
#   name = "instance-pool"

#   instances = [
#     "europe-west3-a/myinstance1",
#     "europe-west3-b/myinstance2",
#   ]

# #   health_checks = [
# #     google_compute_health_check.default.name,
# #   ]
#     project = local.project_init_id
#     region = "europe-west3"
# }