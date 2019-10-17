output "iaas" {
  value = "azure"
}

# output "subscription_id" {
#   sensitive = true
#   value     = "${var.subscription_id}"
# }

#output "tenant_id" {
#  sensitive = true
#  value     = "${var.tenant_id}"
#}

#output "client_id" {
#  sensitive = true
#  value     = "${var.client_id}"
#}

#output "client_secret" {
#  sensitive = true
#  value     = "${var.client_secret}"
#}

##########################
#           PAS          #
##########################
output "credhub_encrypt_key" {
  sensitive = true
  value = "${var.credhub_encrypt_key}"
}
output "mysql_monitor_recipient_email" {
  value = "${var.mysql_monitor_recipient_email}"
}
output "apps_manager_company_name" {
  value = "${var.apps_manager_company_name}"
}
output "push_apps_manager_logo" {
  value = "${var.push_apps_manager_logo}"
}
output "push_apps_manager_square_logo" {
  value = "${var.push_apps_manager_square_logo}"
}
output "push_apps_manager_favicon" {
  value = "${var.push_apps_manager_favicon}"
}
# SAML ONLY
# output "pas_saml_sso_url" {
#   value = "${var.pas_saml_sso_url}"
# }
output "pas_subnet_name" {
  value = "${data.azurerm_subnet.pcf-depl.name}"
}

output "web_lb_name" {
  value = "${module.pas.web_lb_name}"
}

output "diego_ssh_lb_name" {
  value = "${module.pas.diego_ssh_lb_name}"
}

output "mysql_lb_name" {
  value = "${module.pas.mysql_lb_name}"
}

output "tcp_lb_name" {
  value = "${module.pas.tcp_lb_name}"
}

output "sys_domain" {
  value = "sys.${var.dns_suffix}"
}

output "apps_domain" {
  value = "apps.${var.dns_suffix}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
}

output "cf_storage_account_name" {
  value = "${module.pas.cf_storage_account_name}"
}

output "cf_storage_account_access_key" {
  sensitive = true
  value     = "${module.pas.cf_storage_account_access_key}"
}

output "cf_droplets_storage_container" {
  value = "${module.pas.cf_droplets_storage_container_name}"
}

output "cf_packages_storage_container" {
  value = "${module.pas.cf_packages_storage_container_name}"
}

output "cf_resources_storage_container" {
  value = "${module.pas.cf_resources_storage_container_name}"
}

output "cf_buildpacks_storage_container" {
  value = "${module.pas.cf_buildpacks_storage_container_name}"
}

output "network_name" {
  value = "${data.azurerm_virtual_network.pcf-spoke.name}"
}

output "pcf_spoke_resource_group" {
  value = "${data.azurerm_virtual_network.pcf-spoke.resource_group_name}"
}

output "pcf_resource_group_name" {
  value = "${data.azurerm_resource_group.pcf-rg.name}"
}

output "saml_display_name" {
  value = "${var.saml_display_name}"
}