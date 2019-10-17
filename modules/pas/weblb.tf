# resource "azurerm_public_ip" "web-lb-public-ip" {
#  name                         = "web-lb-public-ip"
#  location                     = "${var.location}"
#  resource_group_name          = "${var.resource_group_name}"
#  allocation_method            = "Static"
#  sku                          = "Standard"
#  idle_timeout_in_minutes      = 30
# }

resource "azurerm_lb" "web" {
  name                = "${var.env_name}web-ilb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    subnet_id            = "${var.lb_subnet_id}"
    private_ip_address   = "${var.web_lb_priv_ip}"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "web-backend-pool" {
  name                = "web-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
}

resource "azurerm_lb_probe" "web-https-probe" {
  name                = "web-https-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 443
}

resource "azurerm_lb_rule" "web-https-rule" {
  name                = "web-https-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 443
  backend_port                   = 443
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.web-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.web-https-probe.id}"
}

resource "azurerm_lb_probe" "web-http-probe" {
  name                = "web-http-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"
  protocol            = "TCP"
  port                = 80
}

resource "azurerm_lb_rule" "web-http-rule" {
  name                = "web-http-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 80
  backend_port                   = 80
  idle_timeout_in_minutes        = 30

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.web-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.web-http-probe.id}"
}

resource "azurerm_lb_rule" "web-ntp" {
  name                = "web-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.web.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.web-backend-pool.id}"
}

# resource "azurerm_dns_a_record" "ops_manager_dns" {
#   name                = "pcfweb"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${var.pcfweb_public}"]
# }