# data "azurerm_resource_group" "pcf_network-rg" {
#   name                = "${var.pcf_spoke_resource_group}"
# }
# data "azurerm_virtual_network" "pcf-spoke" {
#   name                = "${var.pcf_spoke_vnet}"
#   resource_group_name = "${data.azurerm_resource_group.pcf_network-rg.name}"
# }

# # data "azurerm_resource_group" "pcf-rg" {
# #   name                = "${var.pcf_resource_group_name}"
# # }

# data "azurerm_subnet" "pcf-depl" {
#   name                 = "${var.pcf_depl_name}"
#   virtual_network_name = "${data.azurerm_virtual_network.pcf-spoke.name}"
#   resource_group_name = "${data.azurerm_resource_group.pcf_network-rg.name}"
# }