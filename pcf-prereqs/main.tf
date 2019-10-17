provider "azurerm" {
  version         = "1.33"
 }

provider "azuread" { version  = "0.6" }

provider "random" { version = "2.2"}

# First, we create a place for everything to live
resource "azurerm_resource_group" "pcf_resource_group" {
  name     = "${var.env_name}-rg1"
  location = "${var.location}"
}

# Second, you'll need a service principal to do work in Azure on PCF's behalf. I create an 
# Application Registration, then associate a Service Principal to that. Finally, I create a 
# password for that Service Principal.
resource "azuread_application" "demo-pcf-app" {
  name                       = "demo-pcf-app"
  oauth2_allow_implicit_flow = true
  available_to_other_tenants = false
}

resource "azuread_service_principal" "demo-pcf-sp" {
  application_id = "${azuread_application.demo-pcf-app.application_id}"
}

resource "azuread_service_principal_password" "demo-pcf-sp-pwd" {
  service_principal_id = azuread_service_principal.demo-pcf-sp.id
  value                = "VT=laksjdYDdD@%nL9Hpd+Tfay_MRV#"
  # If we use a dynamic end_date, the password will always be recreated.
  # end_date             = timeadd(timestamp(),"8760h")
  end_date             = "2020-09-29T22:37:57Z"
}

# Now that we have an Application Registration and a Service Principal, I give it some roles
# within the environment where PCF will be working
# Subscription...
resource "azurerm_role_assignment" "pcfdemo-role-sub" {
  scope              = data.azurerm_subscription.demo.id
  role_definition_id = data.azurerm_role_definition.az-Reader.id
  principal_id       = azuread_service_principal.demo-pcf-sp.id
}

# Resource Group...
resource "azurerm_role_assignment" "pcfdemo-role-rg" {
  scope              = azurerm_resource_group.pcf_resource_group.id
  role_definition_id = data.azurerm_role_definition.az-Contributor.id
  principal_id       = azuread_service_principal.demo-pcf-sp.id
}

# VNET and subnets
resource "azurerm_role_assignment" "pcfdemo-role-vnet" {
  scope              = data.azurerm_virtual_network.pcf-spoke.id
  role_definition_id = data.azurerm_role_definition.az-NetContrib.id
  principal_id       = azuread_service_principal.demo-pcf-sp.id
}

# Also attach a specific group as an owner so the PCF team can administer these components
resource "azurerm_role_assignment" "pcf-team" {
    scope                = "${azurerm_resource_group.pcf_resource_group.id}"
    role_definition_name = "Owner"
    principal_id         = "${data.azuread_group.pcf.id}"
}

# The random_id resource is used to "guarantee" unique resources, especially where we have
# stringent naming requirements like on a Storage Account. This resource will be recreated
# if the Resource Group's ID changes - effectively if we recreate the Resource Group itself
resource "random_id" "storage_account" {
  keepers = {
    sa_id = "${azurerm_resource_group.pcf_resource_group.id}"
  }
  byte_length = 2
}

# Now a Storage Account is created that we can generally put to use. I'm storing some
# Terraform state here, OpsMan VHD, and perhaps Tiles in the future. It's all stored
# in containers that we'll allocate now.
resource "azurerm_storage_account" "pcf_general_sa" {
  name                     = "${var.env_short_name}${random_id.storage_account.hex}"
  resource_group_name      = "${azurerm_resource_group.pcf_resource_group.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "pcf_terraform" {
  name                  = "terraform"
  depends_on            = ["azurerm_storage_account.pcf_general_sa"]
  storage_account_name  = "${azurerm_storage_account.pcf_general_sa.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_container" "ops_manager_storage_container" {
  name                  = "opsmanagerimage"
  depends_on            = ["azurerm_storage_account.pcf_general_sa"]
  storage_account_name  = "${azurerm_storage_account.pcf_general_sa.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "ops_manager_image" {
  name                   = "opsman.vhd"
  storage_account_name   = "${azurerm_storage_account.pcf_general_sa.name}"
  storage_container_name = "${azurerm_storage_container.ops_manager_storage_container.name}"
  resource_group_name   = azurerm_resource_group.pcf_resource_group.name
  source_uri             = "${var.ops_manager_image_uri}"
  type                   = "page"
}

# Since the OpsMan VHD was downloaded into a storage blob above, we can now
# pull that into an image file that can be used with the OpsMan VM created
# later.
resource "azurerm_image" "ops_manager_image" {
  name                = "ops_manager_image"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pcf_resource_group.name}"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "${azurerm_storage_blob.ops_manager_image.url}"
    size_gb  = 150
  }
}