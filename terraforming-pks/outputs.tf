# output "iaas" {
#   value = "azure"
# }

output "subscription_id" {
  sensitive = true
  value     = "${var.subscription_id}"
}

output "tenant_id" {
 sensitive = true
 value     = "${var.tenant_id}"
}


output "pcf_spoke_resource_group" {
  value = "${data.azurerm_virtual_network.pcf-spoke.resource_group_name}"
}

output "network_name" {
  value = "${data.azurerm_virtual_network.pcf-spoke.name}"
}

output "pcf_resource_group_name" {
  value = "${data.azurerm_resource_group.pcf-rg.name}"
}
output "resource_group_name" {
  value = "${data.azurerm_resource_group.pcf-rg.name}"
}
######################
# Outputs for PKS Tile
######################
# output "pks_service_cluster_cidr" {
#   value = "${}"
# }
# output "pks_pod_network_cidr" {
#   value = "${}"
# }

output "pks_api_hostname" {
  value = "api.pks.${var.dns_suffix}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
}

output "default_security_group" {
  value = "${var.env_name}boshvms-nsg1"
}
output "location" {
  value = "${var.location}"
}
output "primary_availability_set" {
  value = "${var.env_name}-aset1"
}
output "vnet_name" {
  value = "${var.env_name}-vnet1"
}
output "pcf_pks_network" {
  value = "pks-services"
}
output "pks_infrastructure_network" {
  value = "${data.azurerm_subnet.pcf-infra.name}"
}
output "pks_lb_name" {
  value = "${var.env_name}pks-ilb"
}

############################
#         LDAP             #
############################
output "ldap_user" {
  value = "${var.ldap_user}"
}
output "ldap_pass" {
  value = "${var.ldap_pass}"
  sensitive = true
}
output "ldap_user_search_base" {
  value = "${var.ldap_user_search_base}"
}
output "ldap_user_search_filter" {
  value = "${var.ldap_user_search_filter}"
}
output "ldap_group_search_base" {
  value = "${var.ldap_group_search_base}"
}
output "ldap_group_search_filter" {
  value = "${var.ldap_group_search_filter}"
}

output "ldap_urls" {
  value = "${var.ldap_urls}"
}