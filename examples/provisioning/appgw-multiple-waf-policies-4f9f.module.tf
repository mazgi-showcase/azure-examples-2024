module "appgw-multiple-waf-policies-4f9f" {
  source                 = "./appgw-multiple-waf-policies-4f9f"
  base_dnsdomain         = "appgw-multiple-waf-policies-4f9f.${var.base_dnsdomain}"
  env_unique_id          = "appgw-multiple-waf-policies-4f9f"
  allowed_ipaddr_list    = var.allowed_ipaddr_list
  azure_default_location = var.azure_default_location
}

output "appgw-multiple-waf-policies-4f9f" {
  sensitive = true
  value = {
    azurerm_application_gateway = {
      main = module.appgw-multiple-waf-policies-4f9f.azurerm_application_gateway.main
    }
    azurerm_linux_web_app = {
      main-linux-docker = module.appgw-multiple-waf-policies-4f9f.azurerm_linux_web_app.main-linux-docker
    }
    azurerm_public_ip = {
      for-main-appgw = module.appgw-multiple-waf-policies-4f9f.azurerm_public_ip.for-main-appgw
    }
  }
}
