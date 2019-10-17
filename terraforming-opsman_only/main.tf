provider "azurerm" {
  version         = "=1.22.0"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/opsman.tfstate"
  }
}

module "infra" {
  source = "../modules/infra"
  env_name                          = "${var.env_name}"
  env_short_name                    = "${var.env_short_name}"
  location                          = "${var.location}"
  dns_subdomain                     = "${var.dns_subdomain}"
  dns_suffix                        = "${var.dns_suffix}"
  pcf_resource_group_name           = "${data.azurerm_resource_group.pcf-rg.name}"
  pcf_infrastructure_subnet         = "${data.azurerm_virtual_network.pcf-spoke.subnets[2]}"
  pcf_virtual_network_address_space = "${data.azurerm_virtual_network.pcf-spoke.address_spaces}"
}

module "ops_manager" {
  source = "../modules/ops_manager"

  env_name            = "${var.env_name}"
  env_short_name      = "${var.env_short_name}"
  location            = "${var.location}"
  resource_group_name = "${data.azurerm_resource_group.pcf-rg.name}"

  vm_count            = "${var.ops_manager_vm ? 1 : 0}"

  ops_manager_vm_size    = "${var.ops_manager_vm_size}"
  ops_manager_image_id   = "${data.azurerm_image.ops-manager-image.id}"
  ops_manager_private_ip = "${var.ops_manager_private_ip}"

  infra_subnet_id     = "${data.azurerm_subnet.pcf-infra.id}"
  infra_subnet_cidr   = "${data.azurerm_subnet.pcf-infra.address_prefix}"
}
