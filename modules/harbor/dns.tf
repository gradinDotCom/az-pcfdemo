
# resource "azurerm_dns_a_record" "harbor" {
#   name                = "harbor"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.pcf_resource_group_name}"
#   ttl                 = "60"
#   #records             = ["${azurerm_lb.harbor.frontend_ip_configuration.0.private_ip_address}"]
#   # brismith Changing to new public until routing in place
#   records             = ["${var.pcf_harbor_public_ip_address}"]
# }