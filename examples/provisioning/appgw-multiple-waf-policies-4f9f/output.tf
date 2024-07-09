output "azurerm_application_gateway" {
  value = {
    main = azurerm_application_gateway.main
  }
}

output "azurerm_linux_web_app" {
  value = {
    main-linux-docker = azurerm_linux_web_app.main-linux-docker
  }
}

output "azurerm_public_ip" {
  value = {
    for-main-appgw = azurerm_public_ip.for-main-appgw
  }
}
