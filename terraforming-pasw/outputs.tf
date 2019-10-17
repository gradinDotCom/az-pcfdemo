# output "kms_host" {
#     value = "${var.kms_host}"
# }

# output "syslog_host" {
#     value = "var.syslog_host"
# }

output "password" {
    sensitive = true
    value = "${var.password}"
}

output "pas_subnet_name" {
  value = "${var.pcf_depl_name}"
}

output "numberOfWinCells" {
    value = "${var.numberOfWinCells}"
}