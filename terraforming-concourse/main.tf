provider "azurerm" {
  version         = "=1.22.0"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/concourse.tfstate"
  }
}
