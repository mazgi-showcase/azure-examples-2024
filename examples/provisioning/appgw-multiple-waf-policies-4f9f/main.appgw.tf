resource "azurerm_public_ip" "for-main-appgw" {
  name                = "${var.env_unique_id}-for-main-appgw"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  backend_address_pool_name             = "backend_address_pool"
  backend_http_settings_name            = "backend_http_settings"
  http_listener_default_name            = "http_listener_default"
  frontend_ip_configuration_public_name = "frontend_ip_configuration_public"
  frontend_http_port_name               = "frontend_http_port"
  probe_name                            = "probe"
  url_path_map_name                     = "url_path_map"
}
resource "azurerm_application_gateway" "main" {
  name                = "${var.env_unique_id}-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [
      azurerm_linux_web_app.main-linux-docker.default_hostname
    ]
  }

  backend_http_settings {
    name                                = local.backend_http_settings_name
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    probe_name                          = local.probe_name
    pick_host_name_from_backend_address = true
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_public_name
    public_ip_address_id = azurerm_public_ip.for-main-appgw.id
  }

  frontend_port {
    name = local.frontend_http_port_name
    port = 80
  }

  gateway_ip_configuration {
    name      = "gateway_ip_configuration"
    subnet_id = azurerm_subnet.main-appgw.id
  }

  http_listener {
    name                           = local.http_listener_default_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_public_name
    frontend_port_name             = local.frontend_http_port_name
    firewall_policy_id             = azurerm_web_application_firewall_policy.main-default.id
    protocol                       = "Http"
  }

  probe {
    name                                      = local.probe_name
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    unhealthy_threshold                       = 3
    timeout                                   = 30
    pick_host_name_from_backend_http_settings = true
    match {
      status_code = ["200-399"]
      body        = ""
    }
  }

  request_routing_rule {
    name                       = "request_routing_rule_path_based"
    priority                   = 1
    rule_type                  = "PathBasedRouting"
    http_listener_name         = local.http_listener_default_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    url_path_map_name          = local.url_path_map_name
  }

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.backend_address_pool_name
    default_backend_http_settings_name = local.backend_http_settings_name
    path_rule {
      name                       = "a-specific-path-map-path-rule"
      paths                      = ["/specific"]
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.backend_http_settings_name
      firewall_policy_id         = azurerm_web_application_firewall_policy.main-for-specific-paths.id
    }
  }
}

# resource "azurerm_monitor_diagnostic_setting" "for-main-appgw" {
#   name                       = "${var.env_unique_id}-for-main-appgw"
#   target_resource_id         = azurerm_application_gateway.main.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
#   log {
#     category = "ApplicationGatewayAccessLog"
#     retention_policy {
#       days    = 0
#       enabled = false
#     }
#   }
#   log {
#     category = "ApplicationGatewayFirewallLog"
#     enabled  = false
#     retention_policy {
#       days    = 0
#       enabled = false
#     }
#   }
#   log {
#     category = "ApplicationGatewayPerformanceLog"
#     retention_policy {
#       days    = 0
#       enabled = false
#     }
#   }
#   metric {
#     category = "AllMetrics"
#     enabled  = true
#     retention_policy {
#       days    = 0
#       enabled = false
#     }
#   }
# }
