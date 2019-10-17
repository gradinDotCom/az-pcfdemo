resource "azurerm_lb" "harbor" {
  name                = "${var.env_id}harbor-ilb"
  location            = "${var.location}"
  sku                 = "Standard"
  resource_group_name = "${var.pcf_resource_group_name}"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id            = "${var.lb_subnet_id}"
    private_ip_address   = "${var.harbor_lb_priv_ip}"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "harbor-backend-pool" {
  name                = "${var.env_id}-harbor-backend-pool"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.harbor.id}"
}

resource "azurerm_lb_probe" "harbor-https-probe" {
  name                = "harbor-https-probe"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.harbor.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "harbor-https-rule" {
  name                = "harbor-https-rule"
  resource_group_name = "${var.pcf_resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.harbor.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.harbor-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.harbor-https-probe.id}"
}

#Do we need a rule?
# resource "azurerm_lb_rule" "harbor-ilb-api-rule" {
#   name                           = "${var.env_id}-harbor-ilb-api-rule"
#   resource_group_name            = "${var.resource_group_name}"
#   loadbalancer_id                = "${azurerm_lb.harbor.id}"
#   protocol                       = "Tcp"
#   frontend_port                  = 443
#   backend_port                   = 443
#   frontend_ip_configuration_name = "${azurerm_public_ip.harbor-ilb-ip.name}"
#   probe_id                       = "${azurerm_lb_probe.harbor-ilb-api-health-probe.id}"
#   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.harbor-ilb-backend-pool.id}"
# }
