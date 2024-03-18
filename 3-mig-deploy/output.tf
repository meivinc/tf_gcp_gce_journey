


output "lb_external_ip" {
  description = "Load balancer externalIP"
  value       = google_compute_global_forwarding_rule.default.ip_address
}
