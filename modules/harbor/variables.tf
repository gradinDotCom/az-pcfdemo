variable "env_id" {}

variable "location" {}

variable "pcf_resource_group_name" {
  type = "string"
}

#variable "pcf_harbor_public_ip" {}

#variable "dns_zone_name" {}

variable "harbor_subnet_id" {}
variable "lb_subnet_id" {}
variable "harbor_lb_priv_ip" {}