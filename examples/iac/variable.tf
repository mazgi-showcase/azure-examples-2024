variable "env_unique_id" {}

variable "allowed_ipaddr_list" {
  type = list(any)
  default = [
    "0.0.0.0/1",
    "128.0.0.0/1",
  ]
}

# See https://github.com/mazgi/domains.provisioning/blob/main/provisioning/google.dns.sandb0x.site.tf
variable "base_dnsdomain" {}

variable "azure_default_location" {}
