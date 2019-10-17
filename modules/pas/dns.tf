

# resource "azurerm_dns_a_record" "apps" {
#   name                = "*.apps"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${var.pcfweb_public}"]
# }

# resource "azurerm_dns_a_record" "sys" {
#   name                = "*.sys"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   # TODO: (2mOlaf) IP should represent plb value instead
#   #records             = ["${azurerm_lb.web.private_ip_address}"]
#   records             = ["${var.pcfweb_public}"]
# }

# resource "azurerm_dns_a_record" "ssh" {
#   name                = "ssh.sys"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${azurerm_lb.diego-ssh.private_ip_address}"]
# }

# resource "azurerm_dns_a_record" "mysql" {
#   name                = "mysql"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${azurerm_lb.mysql.frontend_ip_configuration.0.private_ip_address}"]
# }

# resource "azurerm_dns_a_record" "tcp" {
#   name                = "tcp"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${azurerm_lb.tcp.frontend_ip_configuration.0.private_ip_address}"]
# }
