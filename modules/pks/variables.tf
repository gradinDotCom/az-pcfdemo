variable "env_id" {}

variable "location" {}

# variable "resource_group_name" {
#   type = "string"
# }

variable "network_name" {}

#brismith-removed because we are defining this network
#variable "resource_group_cidr" {}

variable "pks_services_subnet" {}
variable "pks_infra_subnet" {}

#brismith-pks_services should reference ${azurerm_subnet.infrastructure_subnet.name} from ${modules.infra.infrastructure_subnet_name}
#variable "pks_subnet" {}

# locals {
#   # pks_cidr          = "${cidrsubnet(var.resource_group_cidr, 6, 3)}"
#   pks_services_cidr = "${cidrsubnet(var.resource_group_cidr, 6, 4)}"
# }


#variable "dns_zone_name" {}
variable "pcf_resource_group_name" {}
variable "pkslb_subnet_id" {}
variable "pcf_spoke_resource_group" {}
variable "pks_lb_priv_ip" {}