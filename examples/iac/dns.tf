resource "azurerm_dns_zone" "main" {
  name                = var.base_dnsdomain
  resource_group_name = azurerm_resource_group.main.name
}

output "azure_dns_main" {
  value = {
    name         = azurerm_dns_zone.main.name,
    name_servers = azurerm_dns_zone.main.name_servers,
  }
}
