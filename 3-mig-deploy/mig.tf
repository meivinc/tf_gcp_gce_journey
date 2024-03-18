module "eu_mig" {
  source          = "./modules/mig_deployment"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  instance_region = "europe-west3"
  mig_name        = "demo"
  # instance_count  = 1
  template_usage  = module.eu_template.template_uri
  selected_zone = ["europe-west3-a","europe-west3-b"]
  healthcheck_name = google_compute_health_check.autohealing.id
}

module "us_mig" {
  source          = "./modules/mig_deployment"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  instance_region = "us-west1"
  mig_name        = "demo"
  # instance_count  = 1
  template_usage  = module.us_template.template_uri
  selected_zone = ["us-west1-a","us-west1-b"]
  healthcheck_name = google_compute_health_check.autohealing.id
}

module "asia_mig" {
  source          = "./modules/mig_deployment"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  instance_region = "asia-southeast1"
  mig_name        = "demo"
  # instance_count  = 1
  template_usage  = module.asia_template.template_uri
  selected_zone = ["asia-southeast1-a","asia-southeast1-b"]
  healthcheck_name = google_compute_health_check.autohealing.id
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 3
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/healthz"
    port         = "80"
  }
  project = local.project_init_id
}
