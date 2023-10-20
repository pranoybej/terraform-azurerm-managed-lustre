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
  subnet_address_prefixes = ["10.0.1.0/24"]
  create_storage_account  = true
  storage_account_name    = "examplestr09876"
  storage_capacity_in_tb  = 16
  sku_name                = "AMLFS-Durable-Premium-250"
  name                    = "example-luster-01"

  enable_hsm_setting        = true
  filesystem_container_name = "lstr-files"
  logging_container_name    = "lstr-logs"

  identity_type = "UserAssigned"
  identity_ids  = var.ids

  tags = {
    Application = "Azure Managed Lustre"
    Type        = "PaaS"
    Owner       = "Pranoy Bej"
  }
}