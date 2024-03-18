module "eu_template" {
  source          = "./modules/mig_template"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  network_tags    = ["demo-allow-prd", "demo-allow-ubuntu", "demo-allow-ssh"]
  instance_region = local.default_region
}

module "us_template" {
  source          = "./modules/mig_template"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  network_tags    = ["demo-allow-prd", "demo-allow-ubuntu", "demo-allow-ssh"]
  instance_region = "us-west1"
}

module "asia_template" {
  source          = "./modules/mig_template"
  project_id      = local.project_init_id
  subnet_uri      = local.vpc_subnet
  network_tags    = ["demo-allow-prd", "demo-allow-ubuntu", "demo-allow-ssh"]
  instance_region = "asia-southeast1"
}