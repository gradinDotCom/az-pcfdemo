provider "azurerm" {
  version         = "=1.22.0"
  environment     = "${var.cloud_name}"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/pks.tfstate"
  }
}

module "pks" {
  source = "../modules/pks"

  env_id                            = "${var.env_name}"
  location                          = "${var.location}"
  pks_services_subnet               = "${var.pks_services_subnet}"
  pks_infra_subnet                  = "${var.pks_infra_subnet}"
  pcf_resource_group_name           = "${data.azurerm_resource_group.pcf-rg.name}"
  pcf_spoke_resource_group          = "${data.azurerm_resource_group.pcf_network-rg.name}"
  network_name                      = "${data.azurerm_virtual_network.pcf-spoke.name}"
  pkslb_subnet_id        	          = "${data.azurerm_subnet.pcf-lb.id}"
  pks_lb_priv_ip                    = "${var.pks_lb_priv_ip}"
}
