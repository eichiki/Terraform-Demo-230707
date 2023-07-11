# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=>3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "RG-Terraform" {
  name     = "PSM-ASP-TEST-RG"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "ASP-TerraForm" {
  name                = "terraform-appserviceplan"
  location            = azurerm_resource_group.RG-Terraform.location
  resource_group_name = azurerm_resource_group.RG-Terraform.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "AS-Terraform" {
  name                = "app-service-terraform"
  location            = azurerm_resource_group.RG-Terraform.location
  resource_group_name = azurerm_resource_group.RG-Terraform.name
  app_service_plan_id = azurerm_app_service_plan.ASP-TerraForm.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_sql_server.test.fully_qualified_domain_name} Database=${azurerm_sql_database.test.name};User ID=${azurerm_sql_server.test.administrator_login};Password=${azurerm_sql_server.test.administrator_login_password};Trusted_Connection=False;Encrypt=True;"
  }
}

resource "azurerm_sql_server" "test" {
  name                         = "terraform-sqlserver"
  location                     = azurerm_resource_group.RG-Terraform.location
  resource_group_name          = azurerm_resource_group.RG-Terraform.name  
  version                      = "12.0"
  administrator_login          = "vmadmin"
  administrator_login_password = "Qkrtmdtn12#$"
}

resource "azurerm_sql_database" "test" {
  name                = "terraform-sqldatabase"
  location            = azurerm_resource_group.RG-Terraform.location  
  resource_group_name = azurerm_resource_group.RG-Terraform.name  
  server_name         = azurerm_sql_server.test.name

  tags = {
    environment = "production"
  }
}
