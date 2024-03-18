module "vpc_network" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "~> 7.3"

  project_id      = local.project_init_id
  network_name    = "${var.vpc_prefix}-${var.vpc_name}"
  routing_mode    = "GLOBAL"
  shared_vpc_host = "false"
}




