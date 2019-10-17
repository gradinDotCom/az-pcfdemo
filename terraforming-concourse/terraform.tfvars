static_ips                              = "REPLACE_ME"
hostname                                = "concourse.sys.REPLACE_ME_DNS"
dns_zone_name                           = "REPLACE_ME_DNS"
subscription_id                         = "REPLACE_ME"
tenant_id                               = "REPLACE_ME"
client_id                               = "REPLACE_ME"
location                                = "centralus"
client_secret                           = "REPLACE_ME"
admin_password                          = "REPLACE_ME"
admin_password_for_smoketest            = "REPLACE_ME"
env_name                                = "demo-uscentral-pcf"
pcf_lb_subnet                           = "x.x.x.x/26"
pcf_service_subnet                      = "x.x.x.x/22"
pcf_spoke_vnet                          = "REPLACE_ME"
pcf_resource_group_name                 = "REPLACE_ME"
pcf_spoke_resource_group                = "REPLACE_ME"
concourse_lb_priv_ip                    = "x.x.x.x"

##########################
#        SSL KEYS        #
##########################
ssl_cert = <<SSL_CERT
REPLACE_ME
SSL_CERT

ssl_private_key = <<SSL_KEY
REPLACE_ME
SSL_KEY
