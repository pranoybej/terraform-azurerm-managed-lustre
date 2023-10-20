# Declaring Locals for easier reference
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.erg.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.erg.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  vnet_name           = element(coalescelist(data.azurerm_virtual_network.evnet.*.name, azurerm_virtual_network.vnet.*.name, [""]), 0)
  subnet_id           = element(coalescelist(data.azurerm_subnet.esnet.*.id, azurerm_subnet.snet.*.id, [""]), 0)
  storage_name        = element(coalescelist(data.azurerm_storage_account.estr.*.name, azurerm_storage_account.str.*.name, [""]), 0)
  storage_id          = element(coalescelist(data.azurerm_storage_account.estr.*.id, azurerm_storage_account.str.*.id, [""]), 0)
}

# Resource Group Creation or Selection
data "azurerm_resource_group" "erg" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network Creation or Selection
data "azurerm_virtual_network" "evnet" {
  count               = var.create_vnet == false ? 1 : 0
  name                = var.vnet_name
  resource_group_name = var.existing_vnet_rg
}

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = var.vnet_name
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = var.vnet_address_space

  tags = var.tags
}


# Subnet creation or selection
data "azurerm_subnet" "esnet" {
  count                = var.create_subnet == false ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
}

resource "azurerm_subnet" "snet" {
  count                = var.create_subnet ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = var.subnet_address_prefixes
}

# Storage Account Creation or Selection
data "azurerm_storage_account" "estr" {
  count               = var.create_storage_account == false && var.enable_hsm_setting ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = var.existing_storage_rg
}

resource "azurerm_storage_account" "str" {
  count                    = var.create_storage_account && var.enable_hsm_setting ? 1 : 0
  name                     = var.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication
  account_kind             = var.storage_kind
  access_tier              = var.stroage_access_tier

  tags = var.tags
}


# Provision Storage Container for Luster file system hydrating the namespace and archiving from the namespace
resource "azurerm_storage_container" "file_con" {
  count                = var.enable_hsm_setting ? 1 : 0
  name                 = var.filesystem_container_name
  storage_account_name = local.storage_name
}

# Provision Storage Container for Luster file system logging
resource "azurerm_storage_container" "log_con" {
  count                = var.enable_hsm_setting ? 1 : 0
  name                 = var.logging_container_name
  storage_account_name = local.storage_name
}

# Storage Role assignment for lustre file system
data "azuread_service_principal" "hpc" {
  display_name = "HPC Cache Resource Provider"
}

resource "azurerm_role_assignment" "str_con_rl" {
  count                = var.enable_hsm_setting ? 1 : 0
  role_definition_name = "Storage Account Contributor"
  scope                = local.storage_id
  principal_id         = data.azuread_service_principal.hpc.object_id
}

resource "azurerm_role_assignment" "blb_con_rl" {
  count                = var.enable_hsm_setting ? 1 : 0
  role_definition_name = "Storage Blob Data Contributor"
  scope                = local.storage_id
  principal_id         = data.azuread_service_principal.hpc.object_id
}

#Provision an azure managed luster file system
resource "azurerm_managed_lustre_file_system" "lstr" {
  name                   = var.name
  resource_group_name    = local.resource_group_name
  location               = local.location
  subnet_id              = local.subnet_id
  sku_name               = var.sku_name
  storage_capacity_in_tb = var.storage_capacity_in_tb
  zones                  = var.zones

  maintenance_window {
    day_of_week        = var.day_of_week
    time_of_day_in_utc = var.time_of_day_in_utc
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["identity"] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  dynamic "hsm_setting" {
    for_each = var.enable_hsm_setting == true ? ["hsm_setting"] : []

    content {
      container_id         = azurerm_storage_container.file_con[0].resource_manager_id
      logging_container_id = azurerm_storage_container.log_con[0].resource_manager_id
      import_prefix        = var.hsm_import_prefix
    }
  }

  tags = var.tags

}