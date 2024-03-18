# Terraform State - Cloud Storage Location

module "init" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  random_project_id        = true
  random_project_id_length = 4
  default_service_account  = "deprivilege"
  name                     = "${var.project_prefix}-${var.project_name}"
  org_id                   = var.org_id
  billing_account          = var.billing_account
  activate_apis = [
    "billingbudgets.googleapis.com",
    "compute.googleapis.com",
    "networkmanagement.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "dns.googleapis.com"
  ]

  labels = {
    billing_code     = "changeme"
    environment      = "production"
    folder           = "root-level"
  }
}


resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
