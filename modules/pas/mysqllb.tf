resource "azurerm_lb" "mysql" {
  name                = "${var.env_name}mysql-ilb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                  = "frontendip"
    subnet_id             = "${var.lb_subnet_id}"
    private_ip_address    = "${var.mysql_lb_priv_ip}"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "mysql-backend-pool" {
  name                = "mysql-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"
}

resource "azurerm_lb_probe" "mysql-probe" {
  name                = "mysql-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"
  protocol            = "TCP"
  port                = 1936
}

resource "azurerm_lb_rule" "mysql-rule" {
  name                = "mysql-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 3306
  backend_port                   = 3306

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mysql-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.mysql-probe.id}"
}

resource "azurerm_lb_rule" "mysql-ntp" {
  name                = "mysql-ntp-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.mysql.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "UDP"
  frontend_port                  = "123"
  backend_port                   = "123"

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.mysql-backend-pool.id}"
}