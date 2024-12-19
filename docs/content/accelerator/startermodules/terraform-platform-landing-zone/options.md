---
title: Options
geekdocCollapseSection: true
weight: 2
---

The available options are:

* [Customize Management Group Names and IDs](#customize-management-group-names-and-ids)
* [Turn off DDOS protection plan](#turn-off-ddos-protection-plan)
* [Turn off Bastion host](#turn-off-bastion-host)
* [Turn off Private DNS zones and Private DNS resolver](#turn-off-private-dns-zones-and-private-dns-resolver)
* [Turn off Virtual Network Gateways](#turn-off-virtual-network-gateways)
* [Additional Regions](#additional-regions)
* [IP Address Ranges](#ip-address-ranges)
* [Change a policy assignment enforcement mode](#change-a-policy-enforcement-mode)
* [Remove a policy assignment](#remove-a-policy-assignment)
* [Turn off Azure Monitoring Agent](#turn-of-azure-monitoring-agent)

## Customize Management Group Names and IDs

You may want to customize the management groups names and IDs. In order to do this they need to supply a `lib` folder to the accelerator.

The `lib` folder should contain the following structure (we are showing it nested under the standard accelerator file structure here):

```plaintext
📂accelerator
┣ 📂config
┃ ┣ 📂lib
┃ ┃ ┗ 📂architecture_definitions
┃ ┃   ┗ 📜alz.alz_architecture_definition.json
┃ ┗ 📜inputs.yaml
┗ 📂output
```
{{< hint type=warning >}}
The `lib` folder must be named `lib`, any other name will not work
{{< /hint >}}

The `alz.alz_architecture_definition.json` file content should be copied from [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/architecture_definitions/alz.alz_architecture_definition.json).

You can then edit this configuration file to update the management group names and IDs. 

For example to prefix all the management group display names with `Contoso` and update the management group IDs to have the `contoso-` prefix they can update the file to look like this:

{{< include file="/static/examples/tf/accelerator/config/lib/architecture_definitions/alz.alz_architecture_definition.json" language="json" >}}

{{< hint type=tip >}}
When updating the management group `id`, you also need to consider any child management groups that refer to it by the `parent_id`
{{< /hint >}}

Now, when deploying the accelerator they need to supply their lib folder as an argument with `starterAdditionalFiles`:

```pwsh
Deploy-Accelerator -inputs "c:\accelerator\config\inputs.yaml", "c:\accelerator\config\networking.yaml" -starterAdditionalFiles "c:\accelerator\config\lib" -output "c:\accelerator\output"
```

## Turn off DDOS protection plan

You can choose to not deploy a DDOS protection plan. In order to do that, they need to remove the DDOS protection plan configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

{{< hint type=warning >}}
DDOS Protection plan is a critical security protection for public facing services. Carefully consider this and be sure to put in place an alternative solution, such as per IP protection.
{{< /hint >}}

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `ddos_resource_group_name`
  1. `ddos_protection_plan_name`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_group_identifiers`:
  1. `ddos_protection_plan_resource_group_id`
1. To keep the code tidy remove the follow settings from `custom_replacements.resource_identifiers`:
  1. `ddos_protection_plan_id`
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
  1. `ddos_protection_plan_id`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:
    ```terraform
    connectivity = {
      policy_assignments = {
        Enable-DDoS-VNET = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```
1. Remove the whole `ddos_protection_plan` section from `hub_and_spoke_vnet_settings` or `virtual_wan_settings`

## Turn off Bastion host

You can choose to not deploy a Bastion Host. In order to do that, they need to remove the Bastion Host configuration. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `<region>_bastion_subnet_address_prefix` where `<region>` is for each region
1. Remove the whole `bastion` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

## Turn off Private DNS zones and Private DNS resolver

You can choose to not deploy any DNS related resources. In order to do that, they need to remove the DNS configuration and disable the DINE (deploy if not exists) policy. You can either comment out or remove the configuration entirely.

The steps to follow are:

1. To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `dns_resource_group_name`
  1. `<region>_private_dns_resolver_subnet_address_prefix` where `<region>` is for each region
1. Remove the follow configuration settings from `management_group_settings.policy_default_values`:
  1. `private_dns_zone_subscription_id`
  1. `private_dns_zone_region`
  1. `private_dns_zone_resource_group_name`
1. Add the follow section to `management_group_settings.policy_assignments_to_modify`:

    ```terraform
    corp = {
      policy_assignments = {
        Deploy-Private-DNS-Zones = {
          enforcement_mode = "DoNotEnforce"
        }
      }
    }
    ```

1. Remove the whole `private_dns_zones` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

## Turn off Virtual Network Gateways

You can choose to not deploy any Virtual Network Gateways. In order to do that, you need to remove the Virtual Network Gateway configuration. You can either comment out or remove the configuration entirely.

The steps to follow are:

1.  To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `<region>_gateway_subnet_address_prefix` where `<region>` is for each region
1. Remove the whole `virtual_network_gateways` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

You can also just turn off the specific Virtual Network Gateway types you don't want to deploy.

For ExpressRoute Virtual Network Gateways:

1. Remove the whole `express_route` section from the `virtual_network_gateways` section in each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

For VPN Virtual Network Gateways:

1. Remove the whole `vpn` section from the `virtual_network_gateways` section in each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

## Additional Regions

Additional regions are supported. The custom can add up to 10 regions using the out of the box module.

{{< hint type=tip >}}
If you need to scale beyond 10 regions, that can be accommodated by adding additional built in replacements [here](https://github.com/Azure/alz-terraform-accelerator/blob/cf0b37351cd4f2dde9d2cf20642d76bacadf923c/templates/platform_landing_zone/locals.config.tf#L2)
{{< /hint >}}

To add an additional regions, the process is `copy` -> `paste` -> `update`:

1. Copy, paste and update the regional resource group names in `custom_replacements.names`
1. Copy, paste and update the regional IP Ranges in `custom_replacements.names`
1. Copy, paste and update the regional resource group in `connectivity_resource_groups`
1. Copy, paste and update the region in `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs`

## IP Address Ranges

The example configuration files that include connectivity include an out of the box set of ip address ranges. These ranges have been chosen to support a real world scenario with optimal use to avoid ip exhaustion as you scale. However you may not want to use these ranges if they may overlap with their existing ranges or they are planning to scale beyond the /16 per region we cater for.

In order to update the IP ranges, you can update the `custom_replacements.names` section that includes the IP ranges. For example if you prefer to use `172.16` or `192.168`, they could update the ranges as follows:

{{< include file="/static/examples/tf/accelerator/config/custom_replacements.names.ip_ranges.tfvars" language="terraform" >}}

## Change a policy assignment enforcement mode

TODO

## Remove a policy assignment

TODO

## Turn off Azure Monitoring Agent

TODO