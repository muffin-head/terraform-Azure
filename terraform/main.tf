provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo" {
  name = "terraf"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageacct250998"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = ["23.45.1.0/30"]
  }
}
