#brismith - I think we only add this if we need a public IP direct to the LB
# resource "azurerm_public_ip" "pks-ilb-ip" {
#   name                         = "${var.env_id}-pks-ilb-ip"
#   location                     = "${var.location}"
#   resource_group_name          = "${var.pcf_resource_group_name}"
#   allocation_method            = "Static"
#   sku                          = "Standard"
# }

resource "azurerm_lb" "pks-ilb" {
  name                = "${var.env_id}pks-ilb"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${var.pcf_resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id            = "${var.pkslb_subnet_id}"
    private_ip_address   = "${var.pks_lb_priv_ip}"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "pks-ilb-backend-pool" {
  name                = "${var.env_id}-pks-backend-pool"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pks-ilb.id}"
}

resource "azurerm_lb_probe" "pks-ilb-uaa-health-probe" {
  name                = "${var.env_id}-pks-ilb-uaa-health-probe"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pks-ilb.id}"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 8443
}

resource "azurerm_lb_rule" "pks-ilb-uaa-rule" {
  name                           = "${var.env_id}-pks-ilb-uaa-rule"
  resource_group_name            = "${var.pcf_resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.pks-ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 8443
  backend_port                   = 8443
  # Try private_ip_address 
  frontend_ip_configuration_name = "frontendip"
  #frontend_ip_configuration_name = "${azurerm_lb.pks-ilb.frontend_ip_configuration.0.private_ip_address}"
  #frontend_ip_configuration_name = "${azurerm_public_ip.pks-ilb-ip.name}"
  probe_id                       = "${azurerm_lb_probe.pks-ilb-uaa-health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.pks-ilb-backend-pool.id}"
}

resource "azurerm_lb_probe" "pks-ilb-api-health-probe" {
  name                = "${var.env_id}-pks-ilb-api-health-probe"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pks-ilb.id}"
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
  port                = 9021
}

resource "azurerm_lb_rule" "pks-ilb-api-rule" {
  name                           = "${var.env_id}-pks-ilb-api-rule"
  resource_group_name            = "${var.pcf_resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.pks-ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 9021
  backend_port                   = 9021
  frontend_ip_configuration_name = "frontendip"
  #frontend_ip_configuration_name = "${azurerm_public_ip.pks-ilb-ip.name}"
  probe_id                       = "${azurerm_lb_probe.pks-ilb-api-health-probe.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.pks-ilb-backend-pool.id}"
}
