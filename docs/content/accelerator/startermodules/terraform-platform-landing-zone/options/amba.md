---
title: 12 - Deploy Azure Monitoring Baseline Alerts (AMBA)
geekdocCollapseSection: true
weight: 12
---

[Azure Monitoring Baseline Alerts (AMBA)](https://aka.ms/amba) is a set of alerts that are deployed to the Azure Monitor workspace.

Initially, you have to update your library reference to include the AMBA library so you have access to their archetypes.

1. Locate the `terraform.tf` file and amend your `alz` provider library references to include the [latest AMBA version](https://github.com/Azure/Azure-Landing-Zones-Library/tags).

For example:

{{< highlight terraform "linenos=table" >}}
provider "alz" {
  library_overwrite_enabled = true
  library_references = [
     {
      path = "platform/amba"
      ref  = "0000.00.0" # check the latest library version https://github.com/Azure/Azure-Landing-Zones-Library/tags
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
{{< / highlight >}}

2. The AMBA library is now available and you can deploy the [AMBA archetypes](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/amba#archetypes) that suit your organization, in the `alz.alz_architecture_definition.yaml` file. For example, to deploy the `root` AMBA archetype, it would look like:

{{< highlight yaml "linenos=table" >}}
name: alz_custom
management_groups:
  - id: alz
    display_name: Azure Landing Zones
    archetypes:
      - root_custom
      - amba_root
    exists: false
    parent_id: null
{{< / highlight >}}

3. Before deployment, there are a couple of pre-requisites that need to be completed, they include creating a managed identity in order to query Resource Graph for alerts and a resource group to store the alert/monitoring assets. Start by locating the `platform-landing-zone.auto.tfvars` >`custom_replacements` > `names` block setting and add the following code:

{{< highlight terraform "linenos=table" >}}
custom_replacements = {
  names = {
    amba_resource_group_name                 = "rg-amba-$${starter_location_01}"
    amba_user_assigned_managed_identity_name = "uami-mgmt-amba-$${starter_location_01}"
  }
}
{{< / highlight >}}

4. Then in the `main.management.tf` file, paste the following:

{{< hint type=tip >}}
The bootstrap process generates a YAML file by default, but JSON format is also supported. Make sure to use the appropriate decoding function and file extension to correctly parse the architecture definition files.
{{< /hint >}}

{{< highlight terraform "linenos=table" >}}
locals {
  root_management_group_name = yamldecode(file("${path.root}/lib/architecture_definitions/alz.alz_architecture_definition.yaml")).management_groups[0].id

  # root_management_group_name = jsondecode(file("${path.root}/lib/architecture_definitions/alz.alz_architecture_definition.json")).management_groups[0].id
}

module "amba" {
  source  = "Azure/avm-ptn-monitoring-amba-alz/azurerm"
  version = "0.1.1"
  providers = {
    azurerm = azurerm.management
  }
  location                            = var.starter_locations[0]
  root_management_group_name          = local.root_management_group_name
  resource_group_name                 = module.config.custom_replacements.amba_resource_group_name
  user_assigned_managed_identity_name = module.config.custom_replacements.amba_user_assigned_managed_identity_name
}
{{< / highlight >}}

This module creates a resource group and managed identity and it pulls the names from the `custom_replacements` > `names` block.

5. Finally, you need to amend the policy default values that share common parameters like the managed identity, resource group and any other customizations. To achieve this, locate the `platform-landing-zone.auto.tfvars` > `management_group_settings` > `policy_default_values` and append the following code: 

{{< hint type=tip >}}
Ensure you amend the `amba_alz_action_group_email` option if you want to receive email notifications.
{{< /hint >}}

{{< highlight terraform "linenos=table" >}}
management_group_settings = {
  location           = "$${starter_location_01}"
  parent_resource_id = "$${root_parent_management_group_id}"
  policy_default_values = {
    amba_alz_management_subscription_id            = "$${subscription_id_management}"
    amba_alz_resource_group_location               = "$${starter_location_01}"
    amba_alz_resource_group_name                   = "$${amba_resource_group_name}"
    amba_alz_user_assigned_managed_identity_name   = "$${amba_user_assigned_managed_identity_name}"
    amba_alz_action_group_email                    = []
    amba_alz_arm_role_id                           = []
    amba_alz_resource_group_tags                   = {}
    amba_alz_byo_user_assigned_managed_identity_id = ""
    amba_alz_disable_tag_name                      = ""
    amba_alz_disable_tag_values                    = []
    amba_alz_webhook_service_uri                   = []
    amba_alz_event_hub_resource_id                 = []
    amba_alz_function_resource_id                  = ""
    amba_alz_function_trigger_url                  = ""
    amba_alz_logicapp_resource_id                  = ""
    amba_alz_logicapp_callback_url                 = ""
    amba_alz_byo_alert_processing_rule             = ""
    amba_alz_byo_action_group                      = []
  }
}
{{< / highlight >}}

The options for the policy default values and the policies they're used for, can be found in the [Azure Landing Zone AMBA Library](https://github.com/Azure/Azure-Landing-Zones-Library/blob/dae3d4cbcb32520f74bdeba144a95a6486517130/platform/amba/alz_policy_default_values.json).