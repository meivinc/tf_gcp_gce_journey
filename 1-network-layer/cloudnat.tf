/* ----------------------------------------
    Cloud NAT PRD
   ---------------------------------------- */

# Cloud Router configuration for nat 

resource "google_compute_router" "cloud_nat_router" {
  for_each =  {for sub in module.demo_subnet.subnets : sub.name => sub}
  name    = "${var.cloud_router_prefix}-${each.value.region}-compute"
  region  = each.value.region
  network = each.value.network
  project = local.project_init_id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "demo_nat_config" {
  for_each = {for cr in google_compute_router.cloud_nat_router : cr.name => cr}
  name                   = "${var.cloud_nat_prefix}-${each.value.region}-compute"
  router                 = each.value.name
  region                 = each.value.region
  nat_ip_allocate_option = "AUTO_ONLY"
  project                = local.project_init_id

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
