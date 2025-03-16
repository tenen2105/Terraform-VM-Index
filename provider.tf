terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.9.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
  features {}
  client_id = "f8bd6e39-5080-42e7-9cff-a0c900d17112"
  client_secret = "mjF8Q~ESZUAamHGdiFPGYposQ4LUg4X-ZG1debLE"
  tenant_id = "b0ba5a5b-3f5b-44ff-86eb-1b3bac353f7f"
  subscription_id = "e3740935-57ad-46de-91b7-3705809f1a28"
}
