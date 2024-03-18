module "demo_subnet" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "~> 7.3.0"

  project_id   = local.project_init_id
  network_name = module.vpc_network.network_name

  subnets = [
    # Subnet EU
    {
      subnet_name           = "${var.subnet_prefix}-${local.default_region}-compute1"
      subnet_ip             = "192.168.1.0/24"
      subnet_region         = local.default_region
      subnet_private_access = true
    },
    # Subnet US 
    {
      subnet_name           = "${var.subnet_prefix}-us-west1-compute1"
      subnet_ip             = "192.168.2.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = true

    },
    # Subnet ASIA 
    {
      subnet_name           = "${var.subnet_prefix}-asia-southeast1-compute1"
      subnet_ip             = "192.168.3.0/24"
      subnet_region         = "asia-southeast1"
      subnet_private_access = true

    }
  ]
}


