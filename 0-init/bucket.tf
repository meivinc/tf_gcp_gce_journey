# Bucket Creation

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_storage_bucket" "default" {
  name          = "${var.bucket_prefix}-tfstate-${random_string.suffix.result}"
  force_destroy = var.bucket_force_destroy
  location      = var.default_region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  project = module.init.project_id
}