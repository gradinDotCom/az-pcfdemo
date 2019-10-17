provider "azurerm" {
  version         = "=1.22.0"
}

terraform {
  required_version = "< 0.12.0"
  backend "azurerm" {
    storage_account_name = "azpcf295a"
    container_name       = "terraform"
    key                  = "demo-uscentral-pcf/redis.tfstate"
  }
}

locals {
  redis_backup_account          = "${var.redis_backup_account}"
  redis_backup_container        = "${var.redis_backup_container}"
  redis_backup_path             = "${var.redis_backup_path}"
  redis_subnet_name             = "${var.redis_subnet_name}"
  storage_access_key            = "${var.storage_access_key}"
  pcf_svcs_name                 = "${var.pcf_svcs_name}"
}


