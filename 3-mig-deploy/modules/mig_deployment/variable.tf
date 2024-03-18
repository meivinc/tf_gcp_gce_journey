variable "project_id" {
  description = "Project where VM have to be created"
  type        = string

}

variable "network_tags" {
  description = "List network tag needed for VM"
  type        = list(string)
  default     = [null]
}

variable "instance_region" {
  type        = string
  default     = "null"
  description = "Default network region "
}

variable "subnet_uri" {
  description = "subnet URI for VM deployment"
  type        = map(any)

}

variable "subnet_prefix" {
  type        = string
  default     = "sb"
  description = "Subnet default prefix"
}

variable "mig_prefix" {
  type        = string
  default     = "mig"
  description = "mig default prefix"
}

variable "mig_name" {
  type        = string
  default     = "default"
  description = "mig default prefix"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "default vm count"
}

variable "template_usage" {
  type        = string
  default     = null
  description = "default vm count"
}


variable "selected_zone" {
  type        = list(string)
  default     = null
  description = "default vm count"
}

variable "healthcheck_name" {
  type        = string
  default     = null
  description = "default healthcheck"
}
