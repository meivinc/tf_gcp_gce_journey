/* ----------------------------------------
    FIREWALL RULE demo CONFIGURATION
   ---------------------------------------- */


# Deny All 
resource "google_compute_firewall" "demo_deny_egress" {
  name               = "${var.firewall_prefix}-demo-egress-deny-all"
  description        = "Deny Egress all "
  network            = module.vpc_network.network_name
  project            = local.project_init_id
  destination_ranges = ["0.0.0.0/0"]
  priority           = 65535
  direction          = "EGRESS"

  deny {
    protocol = "all"

  }
}

resource "google_compute_firewall" "demo_deny_ingress" {
  name          = "${var.firewall_prefix}-demo-ingress-deny-all"
  description   = "Deny ingress all "
  network       = module.vpc_network.network_name
  project       = local.project_init_id
  source_ranges = ["0.0.0.0/0"]
  priority      = 65535
  direction     = "INGRESS"
  deny {
    protocol = "all"

  }
}

resource "google_compute_firewall" "demo_allow_ssh" {
  name          = "${var.firewall_prefix}-demo-ingress-allow-ssh"
  description   = "Allow ingress ssh "
  network       = module.vpc_network.network_name
  project       = local.project_init_id
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["demo-allow-ssh"]
  priority      = 1000
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "demo_allow_egress_ubuntu" {
  name        = "${var.firewall_prefix}-demo-egress-allow-ubuntu-repo"
  description = "Allow egress to ubuntu repository "
  network     = module.vpc_network.network_name
  project     = local.project_init_id
  destination_ranges = [
    "91.189.91.122",
    "185.125.190.38",
    "185.125.190.41",
    "91.189.91.121",
    "91.189.91.81",
    "91.189.91.83",
    "185.125.190.39",
    "91.189.91.82",
    "185.125.190.36",
    "35.205.202.17",
      # US 
    
    "104.198.11.147",
    "142.250.99.100",
    "142.250.99.101",
    "142.250.99.102",
    "142.250.99.113",
    "142.250.99.138",
    "142.250.99.139",
    "185.125.188.12",
    "185.125.188.87",
    "185.125.190.17",
    "185.125.190.18",
    "185.125.190.36",
    "185.125.190.39",
    "35.203.132.55",
    "35.203.149.125",
    "91.189.91.15",
    "91.189.91.48",
    "91.189.91.49",
    "91.189.91.81",
    "91.189.91.82",
    "91.189.91.83",

    #ASIA 
    "185.125.190.36",
    "185.125.190.39",
    "35.187.226.98",
    "35.197.157.190",
    "35.198.234.238",
    "74.125.200.100",
    "74.125.200.101",
    "74.125.200.102",
    "74.125.200.113",
    "74.125.200.138",
    "74.125.200.139",
    "91.189.91.81",
    "91.189.91.82",
    "91.189.91.83",
  ]
  target_tags = ["demo-allow-ubuntu"]
  priority    = 1000
  direction   = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "demo_allow_egress_google" {
  name        = "${var.firewall_prefix}-demo-egress-allow-google"
  description = "Allow egress to ubuntu repository "
  network     = module.vpc_network.network_name
  project     = local.project_init_id
  destination_ranges = [
    "34.126.0.0/18",
    "199.36.153.8/30",
    "199.36.153.4/30",
    "142.250.0.0/15",
    "74.125.0.0/16",

  ]
  target_tags = ["demo-allow-ubuntu"]
  priority    = 1000
  direction   = "EGRESS"
  allow {
    protocol = "all"
  }
}


resource "google_compute_firewall" "demo_allow_egress_healthcheck" {
  name        = "${var.firewall_prefix}-demo-egress-allow-healthcheck"
  description = "Allow egress to ubuntu repository "
  network     = module.vpc_network.network_name
  project     = local.project_init_id
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
  target_tags = ["demo-allow-ubuntu"]
  priority    = 1000
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }
}

