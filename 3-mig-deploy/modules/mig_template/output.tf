output "template_uri" {
  description = "Instance template"
  value       = google_compute_instance_template.default.self_link_unique
}