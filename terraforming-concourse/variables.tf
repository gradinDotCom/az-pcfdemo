#variable "subscription_id" {}
# variable "client_id" {}
# variable "client_secret" {}
#variable "tenant_id" {}
variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}
variable "static_ips" {}
variable "hostname" {}
variable "ssl_cert" {}
variable "ssl_private_key" {}
variable "env_name" {}
variable "location" {}
variable "pcf_resource_group_name" {}
variable "pcf_spoke_resource_group" {}
variable "pcf_spoke_vnet" {}
variable "concourse_lb_priv_ip" {}