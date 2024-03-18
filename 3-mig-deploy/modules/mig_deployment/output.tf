output "instance_group" {
  description = "Instance group"
  value       = google_compute_region_instance_group_manager.mig_deployment.instance_group
}