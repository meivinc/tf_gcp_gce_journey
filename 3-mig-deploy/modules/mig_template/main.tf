resource "google_compute_instance_template" "default" {
  name        = "mig-compute-template-${var.instance_region}"
  description = "This template is used to create app server instances."
  tags = var.network_tags

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-small"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240110"
    auto_delete  = true
    boot         = true
    disk_size_gb = 10
    # // backup the disk every day
    # resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  network_interface {
    subnetwork = lookup(
      var.subnet_uri,
      "${var.subnet_prefix}-${var.instance_region}-compute1",
      null
    )
    stack_type         = "IPV4_ONLY"
    subnetwork_project = var.project_id

  }

  metadata = {
    enable-oslogin         = "true"
    google-logging-enabled = true
  }
  metadata_startup_script = file("modules/vm_creation/startup-script.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "${data.google_project.prj.number}-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
  project = var.project_id
  region  = var.instance_region
}

data "google_project" "prj" {
  project_id = var.project_id
}

# resource "google_compute_resource_policy" "daily_backup" {
#   name   = "every-day-4am"
#   region = "eu-west3-a"
#   snapshot_schedule_policy {
#     schedule {
#       daily_schedule {
#         days_in_cycle = 1
#         start_time    = "04:00"
#       }
#     }
#   }
# }