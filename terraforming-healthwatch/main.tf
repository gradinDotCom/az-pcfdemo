provider "azurerm" {
  version         = "=1.22.0"
#  subscription_id = "${var.subscription_id}"
#  client_id       = "${var.client_id}"
#  client_secret   = "${var.client_secret}"
#  tenant_id       = "${var.tenant_id}"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/healthwatch.tfstate"
  }
}

locals {
  services_subnet_name         = "${var.pcf_svcs_name}"
  healthwatch_uaa_user         = "${var.healthwatch_uaa_user}"
  healthwatch_uaa_password     = "${var.healthwatch_uaa_password}"
  opsman_url                   = "${var.opsman_url}"
  foundation_name              = "${var.foundation_name}"
}
