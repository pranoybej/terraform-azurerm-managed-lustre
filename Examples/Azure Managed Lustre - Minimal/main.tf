# Azurerm provider configuration
provider "azurerm" {
  features {}
}

#Provision an Azure managed lustre file system

module "lstr01" {
  source                  = "../../"
  create_resource_group   = true
  resource_group_name     = "example-lustre-rg"
  location                = "centralindia"
  create_vnet             = true
  vnet_name               = "lustre-vnet-01"
  vnet_address_space      = ["10.0.0.0/16"]
  create_subnet           = true
  subnet_name             = "lustre-snet-01"
  subnet_address_prefixes = ["10.0.2.0/24"]

  name = "example-luster-02"

  tags = {
    Application = "Azure Managed Lustre"
    Type        = "PaaS"
    Owner       = "Pranoy Bej"
  }
}