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
  default     = null
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