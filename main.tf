terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

// Azure Web App = PaaS = Platform as Service
// App service plan associated with azure web app

resource "azurerm_resource_group" "rg_app" {
  name     = "web-app-chapter"
  location = "West Europe"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "service-plan"
  resource_group_name = azurerm_resource_group.rg_app.name
  location            = azurerm_resource_group.rg_app.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "web_app" {
  name                = "web-app254799"
  resource_group_name = azurerm_resource_group.rg_app.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }
  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_windows_web_app.web_app.id
  repo_url = "https://github.com/Jakub-Lukac/GraphAPI_WebApp.git"
  branch   = "master"
}

