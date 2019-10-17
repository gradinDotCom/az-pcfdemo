resource "azurerm_storage_account" "bosh_root_storage_account" {
  name                     = "${var.env_short_name}director"
  resource_group_name      = "${var.pcf_resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "bosh_storage_container" {
  name                  = "bosh"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${var.pcf_resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "stemcell_storage_container" {
  name                  = "stemcell"
  depends_on            = ["azurerm_storage_account.bosh_root_storage_account"]
  resource_group_name   = "${var.pcf_resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.bosh_root_storage_account.name}"
  container_access_type = "blob"
}

output "bosh_root_storage_account" {
  value = "${azurerm_storage_account.bosh_root_storage_account.name}"
}
