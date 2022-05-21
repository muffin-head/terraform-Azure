provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "terraform25-resources"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                = "terraform25storageacct"
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
resource "azurerm_storage_blob" "example" {
  name                   = "moviesDB.csv"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  source                 = "moviesDB.csv"
}
