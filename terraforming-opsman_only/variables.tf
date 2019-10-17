variable "env_name" {}

variable "env_short_name" {
  description = "Used for creating storage accounts. Must be a-z only, no longer than 10 characters"
}

variable cf_storage_account_name {
  type        = "string"
  description = "storage account name for cf"
  default     = "cf"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {default = ""}

variable "client_secret" {default = ""}

variable "location" {}

variable "pcf_spoke_resource_group" {}

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

variable "ops_manager_vm" {
  default = true
}

variable "ops_manager_image_uri" {}

variable "ops_manager_private_ip" {
  type        = "string"
  description = "IP for the Ops Manager instance if not deploying in the default infrastructure subnet"
  default     = "10.0.8.4"
}

variable "optional_ops_manager_image_uri" {
  default = ""
}

variable "ops_manager_vm_size" {
  type    = "string"
  default = "Standard_DS2_v2"
}

variable "dns_suffix" {}

variable "dns_subdomain" {
  "type"        = "string"
  "description" = "The base subdomain used for PCF. For example, if your dns_subdomain is `cf`, and your dns_suffix is `pivotal.io`, your PCF domain would be `cf.pivotal.io`"
  "default"     = ""
}

variable "pcf_virtual_network_address_space" {
  type    = "list"
  default = ["10.0.0.0/16"]
}

variable "pcf_infrastructure_subnet" {
  type    = "string"
  default = "10.0.8.0/26"
}

variable "pcf_pas_subnet" {
  type    = "string"
  default = "10.0.0.0/22"
}

variable "pcf_services_subnet" {
  type    = "string"
  default = "10.0.4.0/22"
}

variable "pcf_resource_group_name" {
  default = ""
}

variable "credhub_encrypt_key" {
  type    = "string"
  default = "ejdur43Swi65fs2pt645"
}
variable "director_hostname" {}
variable "dns_server" {}
variable "ntp_server" {}
##########################
#       OpsMan SSO       #
##########################
# variable "saml_idp_metadata" {}
# variable "saml_rbac_admin_pcf_resource_group_name" {}
# variable "saml_rbac_groups_attribute" {}
variable "decryption-passphrase" {}

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

variable "ops_manager_image_id" { default = "" }