## Azure Managed Lustre
The Azure Managed Lustre service gives you the capability to quickly create an Azure-based Lustre file system to use in cloud-based high-performance computing jobs.

Lustre is an open-source parallel file system that can scale to massive storage sizes while also providing high performance throughput. It's used by the world's fastest supercomputers and in data-centric workflows for many types of industries. For more information, see https://www.lustre.org.

## Azure Managed Lustre Terraform Module
The Terraform module of Azure Managed Lustre supports creation of Azure Managed Lustre file system. The module is resuable and can be used in any DevOps or CI/CD platform.

## Module Variables
The variables used in the module are given below. Please refer the `variables.tf` file for detailes variables description. 

| Variable Name | Variable Type |
|------|---------|
| create_resource_group | Required |
| resource_group_name | Required |
| location | Optional |
| create_vnet | Optional |
| vnet_name | Required |
| existing_vnet_rg | Optional |
| vnet_address_space | Optional |
| create_subnet | Optional |
| subnet_name | Required |
| subnet_address_prefixes | Optional |
| create_storage_account | Optional |
| existing_storage_rg | Optional |
| storage_account_name | Optional |
| storage_tier | Optional |
| storage_replication | Optional |
| storage_kind | Optional |
| stroage_access_tier | Optional |
| filesystem_container_name | Optional |
| logging_container_name | Optional |
| name | Required |
| sku_name | Optional |
| storage_capacity_in_tb | Optional |
| zones | Optional |
| day_of_week | Optional |
| time_of_day_in_utc | Optional |
| identity_type | Optional |
| identity_ids | Optional |
| enable_hsm_setting | Optional |
| hsm_import_prefix | Optional |
| tags | Optional |

## Module Usage
This module can be used to provision an Azure managed luster file system. You have the ability to create an azure managed luster file system using this module, with or without `hsm setting` and `user managed identity`.


There are specific requirements for this module, which are listed below:

- - Registration of the `Microsoft.StorageCache` provider is essential on the subscription where you intend to provision the resource using this module.

- - Also, The resource creator requires adequate permission for the module to authorize the necessary RBAC role to the entity known as `HPC Cache Resource Provider`. It is compulsory only if the `enable_hsm_setting` variable is set to `true`.


Please have a look at the following example to understand how to use the module.

```terraform

# Azurerm provider configuration
provider "azurerm" {
  features {}
}

#Provision an Azure managed lustre file system

module "lstr01" {
  source                  = "./Azure Managed Lustre"
  create_resource_group   = true
  resource_group_name     = "example-lustre-rg"
  location                = "centralindia"
  create_vnet             = true
  vnet_name               = "lustre-vnet-01"
  vnet_address_space      = ["10.0.0.0/20"]
  create_subnet           = true
  subnet_name             = "lustre-snet-01"
  subnet_address_prefixes = ["10.0.1.0/24"]
  create_storage_account  = true
  storage_account_name    = "exstr09876"
  enable_hsm_setting      = true
  name                    = "example-luster-01"

  tags = {
    Application = "Azure Managed Lustre"
    Type        = "PaaS"
    Owner       = "Pranoy Bej"
  }
}

```

## Module Output
This module exports the following attributes

- `rg_id`            - The ID of the newly created resource group.
- `str_id`           - The ID of the newly created Storage Account.
- `vnet_id`          - The ID of the newly created azure virtual network.
- `snet_id`          - The ID of the newly created azure subnet.
- `lstr_id`          - The ID of the Azure Managed Lustre File System.
