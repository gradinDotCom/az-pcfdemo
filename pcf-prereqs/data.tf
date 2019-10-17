# necessary to data source the subscription ID
data "azurerm_subscription" "demo" {}

# Basic "readers" to fetch the role objects out of AAD
data "azurerm_role_definition" "az-Reader" {
  name                = "Reader"
  scope               = data.azurerm_subscription.demo.id
}

data "azurerm_role_definition" "az-NetContrib" {
  name                = "Network Contributor"
  scope               = data.azurerm_subscription.demo.id
}

data "azurerm_role_definition" "az-Contributor" {
    name               = "Contributor"
    scope               = data.azurerm_subscription.demo.id
}

data "azurerm_role_definition" "az-Owner" {
    name               = "Owner"
    scope               = data.azurerm_subscription.demo.id
}

# This group reader is special and comes from the AzureAD provider
data "azuread_group" "pcf" {
    name = "${var.owner}"
}

# VNET (used by PCF) details
data "azurerm_virtual_network" "pcf-spoke" {
  name                = "${var.pcf_spoke_vnet}"
  resource_group_name = "${var.pcf_spoke_resource_group}"
}