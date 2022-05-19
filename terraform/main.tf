terraform{

    required_providers{
        azurerm={
            version="2.44.0"
            source="hashicorp/azurerm"
        }
    }
}
provider "azurerm" {
  features{

  }
}
resource "azurerm_resource_group" "demo" {
  name = "mytf-rg"
  location = "eastus"
  tags = {
      "terraform"="terraform"
  }
}
