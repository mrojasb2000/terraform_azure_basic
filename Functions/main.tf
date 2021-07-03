# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.65.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create an resource group
resource "azurerm_resource_group" "resource_group" {
  name = "${var.project}_${var.environment}_resource_group"
  location = var.location
}

# Create an storage account
resource "azurerm_storage_account" "storage_account" {
  name = "${var.project}${var.environment}storage"
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

# Create application insights resource
# Application Insights is a component of Azure Monitor which allows you to 
# collect metrics and logs from your function app
resource "azurerm_application_insights" "application_insights" {
  name = "${var.project}_${var.environment}_application_insights"
  location = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type = "Node.JS"
}

# Create an app service plan
# A Function App must always be associated with an App Plan which defines
# the compute resources available to the FA and how it scales.
resource "azurerm_app_service_plan" "app_service_plan" {
  name = "${var.project}_${var.environment}_app_service_plan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  kind = "FunctionApp"
  reserved =  true # this has to be set to true for Linux. Not related to the Premium Plan
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# Create an function app
resource "azurerm_function_app" "function_app" {
  name = "${var.project}-${var.environment}-fun-app"
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insights.instrumentation_key,
  }
  os_type = "linux"
  site_config {
    linux_fx_version = "node|14"
    use_32_bit_worker_process = false
  }
  storage_account_name = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  version = "~3"

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}