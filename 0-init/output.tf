output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.init.project_id
}

output "init_step_terraform_service_account_email" {
  description = "Bootstrap Step Terraform Account"
  value       = google_service_account.service_account.email
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for Foundations"
  value       = google_storage_bucket.default.name
}


output "common_config" {
  description = "Common configuration data to be used in other steps."
  value = {
    org_id          = var.org_id,
    billing_account = var.billing_account,
    default_region  = var.default_region,
    project_prefix  = var.project_prefix,
    folder_prefix   = var.folder_prefix
  }
}