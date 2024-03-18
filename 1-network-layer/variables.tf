/* ----------------------------------------
    General Variable 
   ---------------------------------------- */


variable "remote_state_bucket" {
  description = "Backend bucket to load Terraform Remote State Data from previous steps."
  type        = string
}

variable "dns_name" {
  type        = string
  default     = "private.exemple.com."
  description = "Private DNS Domain"
}


variable "subnet_prefix" {
  type        = string
  default     = "sb"
  description = "Subnet default prefix"
}

variable "vpc_prefix" {
  type        = string
  default     = "vpc"
  description = "vpc default prefix"
}

variable "serverless_prefix" {
  type        = string
  default     = "sac"
  description = "Serverless Access default prefix"
}

variable "firewall_prefix" {
  type        = string
  default     = "fw"
  description = "Firewall Access default prefix"
}

variable "peering_prefix" {
  type        = string
  default     = "np"
  description = "Peering default prefix"
}

variable "default_region" {
  type        = string
  default     = "europe-west3"
  description = "Default network region "
}


variable "vpc_name" {
  type        = string
  default     = "default"
  description = "VPC Name"
}

variable "cloud_router_prefix" {
  type        = string
  default     = "cr"
  description = "cloud router default prefix"
}

variable "cloud_nat_prefix" {
  type        = string
  default     = "cn"
  description = "CloudNat default prefix"
}

# variable "cloud_nat_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable Cloud Nat Deployment"
# }

# variable "cloud_router_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable Cloud Router Deployment"
# }

# variable "cloud_dns_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable Cloud DNS Deployment"
# }