

/* ----------------------------------------
    VM INSTANCE EU CONFIGURATION
   ---------------------------------------- */

module "eu_gce_instances_1" {
  source = "./modules/vm_creation"
  # Specify only name of the instance 
  instance_name      = "demo1"
  instance_env       = "eu"
  machine_type       = "e2-small"
  subnet_uri         = local.vpc_subnet
  network_tags       = ["demo-allow-prd", "demo-allow-ubuntu", "demo-allow-ssh"]
  project_id         = local.project_init_id
  iap_binding_member = var.user_to_iap
  instance_region    = local.default_region
  # allow_update = true
}

/* ----------------------------------------
    VM INSTANCE US CONFIGURATION
   ---------------------------------------- */


module "us_gce_instances_2" {
  source = "./modules/vm_creation"
  # Specify only name of the instance 
  instance_name      = "demo1"
  instance_env       = "us"
  machine_type       = "e2-small"
  subnet_uri         = local.vpc_subnet
  network_tags       = ["demo-allow-prd", "demo-allow-ubuntu", "demo-allow-ssh"]
  project_id         = local.project_init_id
  iap_binding_member = var.user_to_iap
  instance_region    = "us-west1"
  # allow_update = true
}

# # /* ----------------------------------------
# #     VM INSTANCE ASIA CONFIGURATION
# #    ---------------------------------------- */


module "asia_gce_instances_1" {
  source = "./modules/vm_creation"
  # Specify only name of the instance 
  instance_name      = "demo1"
  instance_env       = "asia"
  machine_type       = "e2-small"
  subnet_uri         = local.vpc_subnet
  network_tags       = ["demo-allow-hpd", "demo-allow-ubuntu", "demo-allow-ssh"]
  project_id         = local.project_init_id
  iap_binding_member = var.user_to_iap
  instance_region    = "asia-southeast1"
  # allow_update = true
}