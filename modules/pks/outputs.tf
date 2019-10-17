# output "pks-master-app-sec-group" {
#   value = "${azurerm_application_security_group.pks-master.id}"
# }

# output "pks-api-app-sec-group" {
#   value = "${azurerm_application_security_group.pks-api.id}"
# }

# output "services_subnet_name" {
#   value = "${azurerm_subnet.pks_services.name}"
# }

# output "services_subnet_cidrs" {
#   value = ["${azurerm_subnet.pks_services.address_prefix}"]
# }

# output "services_subnet_gateway" {
#   value = "${cidrhost(azurerm_subnet.pks_services.address_prefix, 1)}"
# }
output "pks_lb_name" {
  value = "${azurerm_lb.pks-ilb.name}"
}