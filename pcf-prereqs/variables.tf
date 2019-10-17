variable "env_name" {}

variable "location" {
  default     = "centralus"
}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "env_short_name" {}

variable "owner" {}
variable "pcf_spoke_vnet" {}
variable "pcf_spoke_resource_group" {}

variable "ops_manager_image_uri" {}