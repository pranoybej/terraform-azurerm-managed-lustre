terraform {
  required_version = ">=1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.72.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.44.0"
    }
  }
}