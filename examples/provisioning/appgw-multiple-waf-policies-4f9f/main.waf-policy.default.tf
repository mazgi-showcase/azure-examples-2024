resource "azurerm_web_application_firewall_policy" "main-default" {
  name                = "${var.env_unique_id}-main-default"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  policy_settings {
    enabled            = true
    mode               = "Prevention"
    request_body_check = true
    # file_upload_limit_in_mb     = 100
    # max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}
