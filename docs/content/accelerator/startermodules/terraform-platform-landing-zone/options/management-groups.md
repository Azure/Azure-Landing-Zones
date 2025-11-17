---
title: 2 - Customize Management Group Names and IDs
geekdocCollapseSection: true
weight: 2
---

You may want to customize the management groups names and IDs.

{{< hint type=warning >}}
If you update the management group IDs, you also need to update the `platform-landing-zone.tfvars` file to match the management group IDs you changed. If you don't do this, you will get errors or unexpected behavior when you deploy the platform landing zone.
{{< /hint >}}

There are 2 high level steps required to customize the management group names and IDs:

1. (Optional) Update the platform landing zone configuration file `platform-landing-zone.tfvars` to reflect any changes to management group IDs
    - (Optional) Update the `management_group_settings` > `subscription_placement` block setting to match any management group IDs you changed.
    - (Optional) Update the `policy_assignments_to_modify` block setting to match any management group IDs you changed.

Follow these steps to customize the management group names and IDs:

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2.

1. The `alz_custom.alz_architecture_definition.json` file contains the management group hierarchy.

1. Edit the `alz_custom.alz_architecture_definition.json` file to update the management group names and IDs.

    For example to prefix all the management group display names with `Contoso` and update the management group IDs to have the `contoso-` prefix they can update the file to look like this:

    {{< hint type=warning >}}
When updating the management group `id`, you also need to update any child management groups that refer to it by the `parent_id`
    {{< /hint >}}

    The `alz_custom.alz_architecture_definition.yaml` file would look like this after making the changes in this example:

    {{< highlight yaml "linenos=table" >}}
    name: alz_custom
    management_groups:
      - id: contoso-alz
        display_name: Contoso
        archetypes:
          - root_custom
        exists: false
        parent_id: null

      - id: contoso-platform
        display_name: Contoso Platform
        archetypes:
          - platform_custom
        exists: false
        parent_id: contoso-alz

      - id: contoso-landingzones
        display_name: Contoso Landing Zones
        archetypes:
          - landing_zones_custom
        exists: false
        parent_id: contoso-alz

      - id: contoso-corp
        display_name: Contoso Corp
        archetypes:
          - corp_custom
        exists: false
        parent_id: contoso-landingzones

      - id: contoso-online
        display_name: Contoso Online
        archetypes:
          - online_custom
        exists: false
        parent_id: contoso-landingzones

      - id: contoso-sandbox
        display_name: Contoso Sandbox
        archetypes:
          - sandbox_custom
        exists: false
        parent_id: contoso-alz

      - id: contoso-management
        display_name: Contoso Management
        archetypes:
          - management_custom
        exists: false
        parent_id: contoso-platform

      - id: contoso-connectivity
        display_name: Contoso Connectivity
        archetypes:
          - connectivity_custom
        exists: false
        parent_id: contoso-platform

      - id: contoso-identity
        display_name: Contoso Identity
        archetypes:
          - identity_custom
        exists: false
        parent_id: contoso-platform

      - id: contoso-decommissioned
        display_name: Contoso Decommissioned
        archetypes:
          - decommissioned_custom
        exists: false
        parent_id: contoso-alz
  {{< /highlight >}}

1. If you updated the `connectivity`, `management` or `identity` management group IDs, then you'll also need to update the `management_group_settings` > `subscription_placement` block setting in the `platform-landing-zone.tfvars` file to match the management group IDs you changed them to.

    For example:

    {{< highlight terraform "linenos=table" >}}
    management_group_settings = {
      subscription_placement = {
        identity = {
          subscription_id       = "$${subscription_id_identity}"
          management_group_name = "contoso-identity"
        }
        connectivity = {
          subscription_id       = "$${subscription_id_connectivity}"
          management_group_name = "contoso-connectivity"
        }
        management = {
          subscription_id       = "$${subscription_id_management}"
          management_group_name = "contoso-management"
        }
      }
    }
    {{< / highlight >}}

1. If you also updated the `alz` management group ID, then you need to update the `policy_assignments_to_modify` block setting in the `platform-landing-zone.tfvars` file to match the management group ID you changed.

    {{< hint type=warning >}}
If you have made any other changes to the `policy_assignments_to_modify` block setting, for example if you have updated policy assignment enforcement mode, then you may need to update the `policy_assignments_to_modify` block setting for other management groups too.
    {{< /hint >}}

    For example:

    {{< highlight terraform "linenos=table" >}}
    policy_assignments_to_modify = {
      contoso-alz = {
        policy_assignments = {
          Deploy-MDFC-Config-H224 = {
            parameters = {
              ascExportResourceGroupName                  = "$${asc_export_resource_group_name}"
              ascExportResourceGroupLocation              = "$${starter_location_01}"
              emailSecurityContact                        = "$${defender_email_security_contact}"
              enableAscForServers                         = "DeployIfNotExists"
              enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
              enableAscForSql                             = "DeployIfNotExists"
              enableAscForAppServices                     = "DeployIfNotExists"
              enableAscForStorage                         = "DeployIfNotExists"
              enableAscForContainers                      = "DeployIfNotExists"
              enableAscForKeyVault                        = "DeployIfNotExists"
              enableAscForSqlOnVm                         = "DeployIfNotExists"
              enableAscForArm                             = "DeployIfNotExists"
              enableAscForOssDb                           = "DeployIfNotExists"
              enableAscForCosmosDbs                       = "DeployIfNotExists"
              enableAscForCspm                            = "DeployIfNotExists"
            }
          }
        }
      }
    }
    {{< / highlight >}}

1. Make sure to save the file after making the changes.
