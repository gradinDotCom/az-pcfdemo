output "iaas" {
  value = "azure"
}

output "subscription_id" {
  sensitive = true
  value     = "${var.subscription_id}"
}

output "tenant_id" {
 sensitive = true
 value     = "${var.tenant_id}"
}

output "client_id" {
 sensitive = true
 value     = "${var.client_id}"
}

output "client_secret" {
 sensitive = true
 value     = "${var.client_secret}"
}

# ##########################
# #        OpsMan          #
# ##########################
output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
}

output "decryption_passphrase" {
  sensitive = true
  value = "${var.decryption-passphrase}"
}

# ##########################
# #       OpsMan SSO       #
# ##########################
# output "saml_idp_metadata" {
#   value = "${var.saml_idp_metadata}"
# }
# output "saml_rbac_admin_pcf_resource_group_name" {
#   value = "${var.saml_rbac_admin_pcf_resource_group_name}"
# }
# output "saml_rbac_groups_attribute" {
#   value = "${var.saml_rbac_groups_attribute}"
# }

# ##########################
# #        Director        #
# ##########################
output "director_hostname" {
  value = "${var.director_hostname}"
}
output "ntp_server" {
  value = "${var.ntp_server}"
}

output "pcf_resource_group_name" {
  value = "${data.azurerm_resource_group.pcf-rg.name}"
}

output "bosh_root_storage_account" {
  value = "${module.infra.bosh_root_storage_account}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_public_key}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_private_key}"
}

output "pcf_spoke_resource_group" {
  value = "${data.azurerm_virtual_network.pcf-spoke.resource_group_name}"
}

output "infrastructure_subnet_name" {
  value = "${data.azurerm_subnet.pcf-infra.name}"
}

output "infrastructure_subnet_cidrs" {
  value = ["${data.azurerm_subnet.pcf-infra.address_prefix}"]
}

output "infrastructure_subnet_gateway" {
  value = "${cidrhost(data.azurerm_subnet.pcf-infra.address_prefix,1)}"
}

output "pas_subnet_name" {
  value = "${data.azurerm_subnet.pcf-depl.name}"
}
output "pas_subnet_cidrs" {
  value = ["${data.azurerm_subnet.pcf-depl.address_prefix}"]
}

output "pas_subnet_gateway" {
  value = "${cidrhost(data.azurerm_subnet.pcf-depl.address_prefix, 1)}"
}

output "services_subnet_name" {
  value = "${data.azurerm_subnet.pcf-svcs.name}"
}

output "services_subnet_cidrs" {
  value = ["${data.azurerm_subnet.pcf-svcs.address_prefix}"]
}

output "services_subnet_gateway" {
  value = "${cidrhost(data.azurerm_subnet.pcf-svcs.address_prefix,1)}"
}

output "pks_subnet_name" {
  value = "${data.azurerm_subnet.pcf-pks.name}"
}

output "pks_subnet_cidrs" {
  value = ["${data.azurerm_subnet.pcf-pks.address_prefix}"]
}

output "pks_subnet_gateway" {
  value = "${cidrhost(data.azurerm_subnet.pcf-pks.address_prefix,1)}"
}

output "dns_server" {
  value     = "${var.dns_server}"
}
output "network_name" {
  value = "${data.azurerm_virtual_network.pcf-spoke.name}"
}