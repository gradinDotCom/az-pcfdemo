data "azurerm_resource_group" "pcf_network-rg" {
  name                = "${var.pcf_spoke_resource_group}"
}
data "azurerm_virtual_network" "pcf-spoke" {
  name                = "${var.pcf_spoke_vnet}"
  resource_group_name = "${data.azurerm_resource_group.pcf_network-rg.name}"
}

data "azurerm_resource_group" "pcf-rg" {
  name                = "${var.pcf_resource_group_name}"
}
data "azurerm_subnet" "pcf-svcs" {
  name                 = "${var.pcf_svcs_name}"
  virtual_network_name = "${data.azurerm_virtual_network.pcf-spoke.name}"
  resource_group_name  = "${var.pcf_spoke_resource_group}"
}
data "azurerm_subnet" "pcf-lb" {
  name                 = "pcf_lb"
  virtual_network_name = "${data.azurerm_virtual_network.pcf-spoke.name}"
  resource_group_name  = "${data.azurerm_resource_group.pcf_network-rg.name}"
}