resource "azurerm_service_plan" "main-linux-docker" {
  name                = "${var.env_unique_id}-main-linux-docker"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = {}
}

resource "azurerm_linux_web_app" "main-linux-docker" {
  name                                     = "${var.env_unique_id}-main-linux-docker"
  app_settings                             = {}
  ftp_publish_basic_authentication_enabled = true
  https_only                               = false
  location                                 = azurerm_resource_group.main.location
  resource_group_name                      = azurerm_resource_group.main.name
  service_plan_id                          = azurerm_service_plan.main-linux-docker.id
  site_config {
    application_stack {
      docker_image_name = "ghcr.io/mazgi/http-ok-whatever:latest"
    }
  }
  tags                                           = {}
  webdeploy_publish_basic_authentication_enabled = true
}
