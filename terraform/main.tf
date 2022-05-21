provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "terraform25-resources"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                = "${var.prefix}storageacct"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_container" "example" {
  name                  = "terraform25storagecontainer"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}

resource "azurerm_storage_account" "example2" {
  name                = "terraform25storageacct2"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "LRS"
  enable_https_traffic_only       = true
  access_tier                     = "Hot"
  allow_nested_items_to_be_public = true
}

resource "azurerm_storage_container" "example2" {
  name                  = "terraform25storagecontainer2"
  storage_account_name  = azurerm_storage_account.example2.name
  container_access_type = "blob"
}
