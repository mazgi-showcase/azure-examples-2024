resource "azurerm_web_application_firewall_policy" "main-for-specific-paths" {
  name                = "${var.env_unique_id}-main-for-specific-paths"
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
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"

      # https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=owasp32#crs931-32
      rule_group_override {
        rule_group_name = "REQUEST-931-APPLICATION-ATTACK-RFI"
        # 931130	Possible Remote File Inclusion (RFI) Attack: Off-Domain Reference/Link
        rule {
          id      = "931130"
          action  = "Log"
          enabled = true
        }
      }
      # https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=owasp32#crs920-32
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        # 920320	Missing User Agent Header
        rule {
          id      = "920320"
          action  = "Log"
          enabled = true
        }
        # 920330	Empty User Agent Header
        rule {
          id      = "920330"
          action  = "Log"
          enabled = true
        }
      }
    }
  }
}
