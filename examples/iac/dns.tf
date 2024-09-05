resource "azurerm_dns_zone" "main" {
  name                = var.base_dnsdomain
  resource_group_name = azurerm_resource_group.main.name
}
