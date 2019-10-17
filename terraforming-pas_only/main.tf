provider "azurerm" {
  version         = "=1.22.0"
}
terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/pas.tfstate"
  }
}
module "pas" {
  source = "../modules/pas"

  env_name       = "${var.env_name}"
  location       = "${var.location}"
  env_short_name = "${var.env_short_name}"

  pas_subnet_id        = "${data.azurerm_subnet.pcf-depl.id}"
  pas_subnet_cidr      = "${data.azurerm_subnet.pcf-depl.address_prefix}"
  services_subnet_id   = "${data.azurerm_subnet.pcf-svcs.id}"
  services_subnet_cidr = "${data.azurerm_subnet.pcf-svcs.address_prefix}"
  lb_subnet_id         = "${data.azurerm_subnet.pcf-lb.id}"

  cf_storage_account_name              = "${var.cf_storage_account_name}"
  cf_buildpacks_storage_container_name = "${var.cf_buildpacks_storage_container_name}"
  cf_droplets_storage_container_name   = "${var.cf_droplets_storage_container_name}"
  cf_packages_storage_container_name   = "${var.cf_packages_storage_container_name}"
  cf_resources_storage_container_name  = "${var.cf_resources_storage_container_name}"

  resource_group_name                 = "${data.azurerm_resource_group.pcf-rg.name}"
  network_name                        = "${data.azurerm_virtual_network.pcf-spoke.name}"
  pcf_spoke_resource_group            = "${data.azurerm_virtual_network.pcf-spoke.resource_group_name}"
  web_lb_priv_ip                      = "${var.web_lb_priv_ip}"
  diego_lb_priv_ip                    = "${var.diego_lb_priv_ip}"
  mysql_lb_priv_ip                    = "${var.mysql_lb_priv_ip}"
  tcp_lb_priv_ip                      = "${var.tcp_lb_priv_ip}"
}