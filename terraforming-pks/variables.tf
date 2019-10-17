variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "env_name" {}

variable "env_short_name" {}

variable "dns_suffix" {
  default = ""
}

# variable "dns_subdomain" {
#   "type"        = "string"
#   "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
#   "default"     = ""
# }

variable "pcf_spoke_resource_group" {
  type    = "string"
}
variable "pcf_resource_group_name" {
  type    = "string"
}
variable "pks_services_subnet" {
  type    = "string"
}

variable "pcf_depl_name" {
  type    = "string"
  }
variable "pcf_infra_name" {
  type    = "string"
  }
variable "pcf_svcs_name" {
  type    = "string"
  }
variable "pcf_spoke_vnet" {
  type    = "string"
  }
variable "pcf_pks_network" {
  type    = "string"
  }
#########################
# Variables for PKS Tile
#########################
variable "ssl_cert" {
  default = ""
}

variable "ssl_private_key" {
  default = ""
}

variable "location" {
  default     = "centralus"
}
variable "pks_infra_subnet" {}

variable "pks_lb_priv_ip" {}


############################
#         LDAP             #
############################
variable "ldap_user" {}
variable "ldap_pass" {}
variable "ldap_user_search_base" {}
variable "ldap_user_search_filter" {
  default = "samAccountName={0}"
}
variable "ldap_group_search_base" {}
variable "ldap_group_search_filter" {
  default = "member={0}"
}

variable "ldap_urls" {}