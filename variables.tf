# The variables section of Azure Managed Luster module

variable "create_resource_group" {
  type        = bool
  description = "(Optional) Do you have a Resource Group or want to create a new one ?"
  default     = false
}

variable "resource_group_name" {
  description = "(Required) The name of an existing resource group to be imported."
  type        = string
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the Azure Container Registry should exist."
  default     = ""
}

variable "create_vnet" {
  type        = bool
  description = "(Optional) Do you have an exiting azure virtual network or want to create a new one?"
  default     = false
}

variable "vnet_name" {
  type        = string
  description = "(Required) The name of the virtual network."
}

variable "existing_vnet_rg" {
  type        = string
  description = "(Optional) What is the name of the resource group where the virtual network exists?"
  default     = ""
}

variable "vnet_address_space" {
  type        = list(string)
  description = "(Optional) The address space that is used the virtual network. You can supply more than one address space."
  default     = [""]
}

variable "create_subnet" {
  type        = bool
  description = "(Optional) Do you have an exiting azure subnet or want to create a new one?"
  default     = false
}

variable "subnet_name" {
  type        = string
  description = "(Required) The name of the azure subnet."
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "(Optional) The address prefixes to use for the subnet. It is required to have at least a /24 subnet mask within the Virtual Network's address space."
  default     = [""]
}

variable "create_storage_account" {
  type        = bool
  description = "(Optional) Do you have an exiting azure storage account or want to create a new one?"
  default     = false
}

variable "existing_storage_rg" {
  type        = string
  description = "(Optional) What is the name of the resource group where the storage account exists?"
  default     = ""
}

variable "storage_account_name" {
  type        = string
  description = "(Optional) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed."
  default     = ""
}

variable "storage_tier" {
  type        = string
  description = "(Optional) Defines the Tier to use for this storage account."
  default     = "Standard"
}

variable "storage_replication" {
  type        = string
  description = " (Optional) Defines the type of replication to use for this storage account."
  default     = "LRS"
}

variable "storage_kind" {
  type        = string
  description = "(Optional) Defines the access tier for this storage acccount."
  default     = "StorageV2"
}

variable "stroage_access_tier" {
  type        = string
  description = "(Optional) Defines the access tier for the Stroage Account."
  default     = "Hot"
}

variable "filesystem_container_name" {
  type        = string
  description = "(Optional) The name of the storage container that is used for hydrating the namespace and archiving from the namespace."
  default     = "lustre-files"
}

variable "logging_container_name" {
  type        = string
  description = "The name of the storage container that is used for logging events and errors."
  default     = "lustre-logging"
}

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Azure Managed Lustre File System."
}

variable "sku_name" {
  type        = string
  description = "(Optional) The SKU name for the Azure Managed Lustre File System. Possible values are `AMLFS-Durable-Premium-40`, `AMLFS-Durable-Premium-125`, `AMLFS-Durable-Premium-250` and `AMLFS-Durable-Premium-500`."
  default     = "AMLFS-Durable-Premium-250"
}

variable "storage_capacity_in_tb" {
  type        = number
  description = "(Optional) The size of the Azure Managed Lustre File System in tebibyte (TiB). The valid values for this field are dependant on which `sku_name` has been defined in the configuration file. For more information on the valid values for this field please see the offical azure documentation."
  default     = 8
}

variable "zones" {
  type        = set(string)
  description = "(Optional) A list of availability zones for the Azure Managed Lustre File System. "
  default     = ["2"]
}

variable "day_of_week" {
  type        = string
  description = "(Optional) The day of the week on which the maintenance window will occur."
  default     = "Sunday"
}

variable "time_of_day_in_utc" {
  type        = string
  description = "(Optional) The time of day in UTC to start the maintenance window."
  default     = "21:00"
}

variable "identity_type" {
  type        = string
  description = "(Optional) The type of Managed Service Identity that should be configured on this Azure Managed Lustre File System. Only possible value is `UserAssigned`."
  default     = null
}

variable "identity_ids" {
  type        = set(string)
  description = "A list of User Assigned Managed Identity IDs to be assigned to this Azure Managed Lustre File System. This value is required when `identity_type` is set to `UserAssigned`."
  default     = null
}

variable "enable_hsm_setting" {
  type        = bool
  description = "(Optional) Do you want to enable HSM setting of azure managed lustre file system?"
  default     = false
}

variable "hsm_import_prefix" {
  type        = string
  description = "The import prefix for the Azure Managed Lustre File System. Only blobs in the non-logging container that start with this path/prefix get hydrated into the cluster namespace."
  default     = "/lstr"
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = null
}