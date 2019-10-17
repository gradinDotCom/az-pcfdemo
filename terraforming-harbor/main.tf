provider "azurerm" {
  version         = "=1.22.0"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/harbor.tfstate"
  }
}

module "harbor" {
  source = "../modules/harbor"
  env_id                              = "${var.env_name}"
  location                            = "${var.location}"
  pcf_resource_group_name             = "${var.pcf_resource_group_name}"
  harbor_subnet_id                    = "${data.azurerm_subnet.pcf-svcs.id}"
  lb_subnet_id                        = "${data.azurerm_subnet.pcf-lb.id}"
  harbor_lb_priv_ip                   = "${var.harbor_lb_priv_ip}"
}