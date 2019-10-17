##############################
##  <CONTRACTS>             ##
##  These are items which   ##
##  we are fully dependent  ##
##  upon and represent an   ##
##  agreement set forth     ##
##  with a 'provider.'      ##
##############################

env_name                            = "demo-uscentral-pcf"
storage_account_name                = "azpcf295a"
env_short_name                      = "azpcf"
location                            = "centralus"
dns_suffix                          = "turtleisland.net"
vm_admin_username                   = "admin"
foundation_name                     = "lower"

ldap_user                           = "splinter@turtleisland.net.net"
ldap_pass                           = "%2bRcq%dfsfsdfwqeqwewq%3d%3d"
ldap_user_search_base               = "OU=Users,DC=turtleisland,DC=net"
ldap_group_search_base              = "OU=Groups,DC=turtleisland,DC=net"
ldap_urls                           = "ldap://adserver.turtleisland.net ldap://adserver2.turtleisland.net"
###################
##  SPOKE DEETS  ##
###################
# env_name makes up a large part of the resources created by this script, but also
# represents the prefix of our pre-defined resource group (i.e. env_name-rg1).
env_name                              = "demo-uscentral-pcf"
pcf_resource_group_name               = "demo-uscentral-pcf-rg1"
pcf_spoke_resource_group              = "etg-uscentral-etgci-pcfspoke-rg1"
pcf_spoke_vnet                        = "etg-uscentral-etgci-pcf-vnet1"
pcf_infra_name                        = "infra"
pcf_svcs_name                         = "services"
pcf_depl_name                         = "deploy"
pcf_pks_network                       = "pks-services"
ntp_server                            = "10.44.32.133"
dns_server                            = "10.44.32.135"
pks_services_subnet                   = "10.44.36.0/22"
pks_infra_subnet                      = "10.44.32.32/27"
pks_lb_priv_ip                        = "10.44.32.68"

##########################
#        SSL KEYS        #
##########################
ssl_cert = <<SSL_CERT
-----BEGIN CERTIFICATE-----
MIID9zCCAt8CFBBfDRALihfY7cznWtPPSLGrbmyKMA0GCSqGSIb3DQEBCwUAMIG3
MQswCQYDVQQGEwJVUzEQMA4GA1UECAwHR2VvcmdpYTETMBEGA1UEBwwKQWxwaGFy
ZXR0YTEPMA0GA1UECgwGRmlzZXJ2MR4wHAYDVQQLDBVFbnRlcnByaXNlIFRlY2hu
b2xvZ3kxGzAZBgNVBAMMEioudHVydGxlaXNsYW5kLm5ldDEzMDEGCSqGSIb3DQEJ
ARYkcGNmYWRtaW5zQGZpc2VydmNvcnAub25taWNyb3NvZnQuY29tMB4XDTE5MDky
MDE1NDkxNVoXDTIyMDcxMDE1NDkxNVowgbcxCzAJBgNVBAYTAlVTMRAwDgYDVQQI
DAdHZW9yZ2lhMRMwEQYDVQQHDApBbHBoYXJldHRhMQ8wDQYDVQQKDAZGaXNlcnYx
HjAcBgNVBAsMFUVudGVycHJpc2UgVGVjaG5vbG9neTEbMBkGA1UEAwwSKi50dXJ0
bGVpc2xhbmQubmV0MTMwMQYJKoZIhvcNAQkBFiRwY2ZhZG1pbnNAZmlzZXJ2Y29y
cC5vbm1pY3Jvc29mdC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQC/70VWS9IdwUVyiSyZpyoeTc7TsU8bd9SvhDGQr8bqCuJrTF7Ek5xOHelv8AbI
5rWnSOgermmkGObQQG+gVw689p++ew7i/scgyighVK/T2oQ+iALzfLU9SoQrtJ6I
i9BTMAzecxqNXUOnzGKJNB3/eJHzoSWjZoU1DmIIOxFf7fRpm/atJkTzaqjoAfL+
9sjva6gCpYoDRm/GzRFDG5C0i6/ncI27lvFbmWJlkRi6eYZ2EMSUlG68Lqi7fkm/
LbLmLlaW4A/hCMFfea5Ze8OonWz+339RAm/jPzG93qV9e7NZ/mB7v4Gayy2h/cOO
FuC60Bcl9Wdza7zQ0LE9vFDfAgMBAAEwDQYJKoZIhvcNAQELBQADggEBADxRbbFa
p6NgDglX6j1A0bMmbJm+1nVoK5oLq0E2fQ9vLcipCQVcnG42Oo28EqTR6pGQgriz
827lxUA6PMXcOy+oY/uzSrhozDR90I1FNDL4EspqfCgC9iY58n64mLuFgeFtoTcS
MKWXNs57WLdh1Q/kdV267Aq3ojrp9qiOC2n9yQV/5kXbg729OfvMDPjyX/HCA+8h
NT3Fv0+ELXwATagyXAgLvY6wxp7UOeJ8hgTyZJwkxxAJkMJuWmMHjU0HW2Ypn0CZ
WqTc8UhWe1X222MCKn71M661ERhMTy6I8vKftacgD8NYtlQIDYXbU1jl/EtIIHaF
aAmeiSK+Djawn/0=
-----END CERTIFICATE-----
SSL_CERT

ssl_private_key = <<SSL_KEY
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
SSL_KEY

