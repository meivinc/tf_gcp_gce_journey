/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
# data "google_compute_zones" "available" {
#   region = var.instance_region
#   project = var.project_id
# }

data "google_project" "current" {
  project_id = var.project_id
}

resource "google_compute_instance" "compute-instance" {

  boot_disk {
    auto_delete = true
    device_name = "instance-1"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240110"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type              = var.machine_type
  allow_stopping_for_update = var.allow_update
  metadata = {
    enable-oslogin = "true"
    google-logging-enabled=true
    # startup-script = file("startup-script.sh")

  }

  metadata_startup_script = file("modules/vm_creation/startup-script.sh")
  name = "${var.instance_prefix}-${var.instance_env}-${var.instance_region}-${var.instance_name}"

  # network_interface {
  #   queue_count = 0
  #   stack_type  = "IPV4_ONLY"
  #   subnetwork  = var.subnet_uri
  # }
  network_interface {
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork = lookup(
      var.subnet_uri,
      "${var.subnet_prefix}-${var.instance_region}-compute1",
      null

    )
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "${data.google_project.current.number}-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  # count = length(data.google_compute_zones.available.names)
  tags = var.network_tags
  # zone    = data.google_compute_zones.available.names[count.index]
  zone    = "${var.instance_region}-a"

  project = var.project_id

}
