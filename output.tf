# The output section of Azure Managed Luster module

output "rg_id" {
  description = "The ID of the newly created Resource Group."
  value       = var.create_resource_group ? azurerm_resource_group.rg.*.id : null
}

output "str_id" {
  description = "The ID of the newly created Storage Account."
  value       = var.create_storage_account && var.enable_hsm_setting ? azurerm_storage_account.str.*.id : null
}

output "vnet_id" {
  description = "The ID of the newly created azure virtual network."
  value       = var.create_vnet ? azurerm_virtual_network.vnet.*.id : null
}

output "snet_id" {
  description = "The ID of the newly created azure subnet."
  value       = var.create_subnet ? azurerm_subnet.snet.*.id : null
}

output "lstr_id" {
  description = "The ID of the Azure Managed Lustre File System."
  value       = azurerm_managed_lustre_file_system.lstr.id
}