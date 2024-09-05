output "azure_dns_main" {
  sensitive = true
  value = {
    name         = azurerm_dns_zone.main.name,
    name_servers = azurerm_dns_zone.main.name_servers,
  }
}
