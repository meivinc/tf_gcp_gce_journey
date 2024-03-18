/* ----------------------------------------
    DNS Workaround Configuration
   ---------------------------------------- */

variable "remote_state_bucket" {
  description = "Backend bucket to load Terraform Remote State Data from previous steps."
  type        = string
}

variable "user_to_iap" {
  type        = string
  default     = ""
  description = "user or group to allow to IAP "
}

variable "gce_prefix" {
  type        = string
  default     = "ins"
  description = "Subnet default prefix"
}