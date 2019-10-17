variable "pcf_resource_group_name" {}
variable "pcf_spoke_resource_group" {}
variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable cf_storage_account_name {
  type        = "string"
  description = "storage account name for cf"
  default     = "cf"
}

variable cf_buildpacks_storage_container_name {
  type        = "string"
  description = "container name for cf buildpacks"
  default     = "buildpacks"
}

variable cf_packages_storage_container_name {
  type        = "string"
  description = "container name for cf packages"
  default     = "packages"
}

variable cf_droplets_storage_container_name {
  type        = "string"
  description = "container name for cf droplets"
  default     = "droplets"
}

variable cf_resources_storage_container_name {
  type        = "string"
  description = "container name for cf resources"
  default     = "resources"
}
variable "saml_display_name" {
  type        = "string"
  description = "Display for the SAML login"
  default     = "My SAML"
}
##variable "subscription_id" {}

#variable "tenant_id" {}

#variable "client_id" {}

#variable "client_secret" {}

variable "location" {}

variable "ssl_cert" {
  type        = "string"
  description = "the contents of an SSL certificate which should be passed to the gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_private_key" {
  type        = "string"
  description = "the contents of an SSL private key which should be passed to the gorouter, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_ca_cert" {
  type        = "string"
  description = "the contents of a CA public key to be used to sign a generated certificate for gorouter, optional if `ssl_cert` is provided"
  default     = ""
}

variable "ssl_ca_private_key" {
  type        = "string"
  description = "the contents of a CA private key to be used to sign a generated certificate for gorouter, optional if `ssl_cert` is provided"
  default     = ""
}

variable "dns_suffix" {}

variable "dns_subdomain" {
  "type"        = "string"
  "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
}
variable "pcf_spoke_vnet" {}
###########################
#         PAS             #
###########################
variable "credhub_encrypt_key" {}
variable "apps_manager_company_name" {
  "type"        = "string"
}
variable "push_apps_manager_favicon" {}
variable "push_apps_manager_square_logo" {}
variable "push_apps_manager_logo" {}
#SAML ONLY
# variable "pas_saml_sso_url" {
#     "description" = "SAML SSO for PAS"
# }
# variable "pcf_infrastructure_subnet" {}
variable "web_lb_priv_ip" {}
variable "diego_lb_priv_ip" {}
variable "mysql_lb_priv_ip" {}
variable "tcp_lb_priv_ip" {}
variable "pcf_svcs_name" {
  type    = "string"
}

variable "mysql_monitor_recipient_email" {
  type    = "string"
}
variable "pcf_depl_name" {
  type    = "string"
  }
variable "pcf_infra_name" {
  type    = "string"
  }