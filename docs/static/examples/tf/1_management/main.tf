locals {
  management_resource_suffix     = "changeme"
  management_resource_group_name = "rg-alzmanagement"
  automation_account_name        = "aa-${local.management_resource_suffix}"
  log_analytics_workspace_name   = "law-${local.management_resource_suffix}"
  location                       = "swedencentral"
}

provider "azurerm" {
  features {}
}

module "alz_management" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.4.0"

  automation_account_name      = local.automation_account_name
  location                     = local.location
  log_analytics_workspace_name = local.log_analytics_workspace_name
  resource_group_name          = local.management_resource_group_name
}
