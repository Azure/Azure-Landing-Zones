---
title: Release Notes
description: Release notes for the Accelerator Terraform Platform Landing Zone Starter Module
weight: 30
---

This page contains the release notes for the ALZ IaC Accelerator.

This page will only list changes that have been identified as breaking and may require action to be taken by the user to complete our [Upgrade Guidance]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/upgrade-guide" >}}).

To find the individual release notes for each component of the accelerator, please refer to the following links:

- [ALZ PowerShell Module](https://github.com/Azure/ALZ-PowerShell-Module/releases)
- [Accelerator Bootstrap Modules](https://github.com/Azure/accelerator-bootstrap-modules/releases)
- [Terraform Starter Modules](https://github.com/Azure/alz-terraform-accelerator/releases)
- [Bicep Starter Modules](https://github.com/Azure/ALZ-Bicep/releases)

## Breaking changes

While we try very hard to avoid breaking changes, there are times when a feature request, product launch, or Cloud Adoption Framework guidance necessitates us updating the accelerator in a way that may require updates to configuration while updating your code base.

## Release Notes

### [Terraform Starter Module - v9.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v9.0.0)

- Release date: 2025-09-12
- Release link: [v9.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v9.0.0)
- Release diff: [v8.1.1...v9.0.0](https://github.com/Azure/alz-terraform-accelerator/compare/v8.1.1...v9.0.0

This release introduces the Security management group and platform subscription.

This is on by default, but the code is backwards compatible.

In order for a customer to not deploy the Security management group, they need to:

- Remove it from the [architecture definition file](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/lib/architecture_definitions/alz_custom.alz_architecture_definition.yaml)
- Remove it from the [subscription placements in the platform landing zone configuration file](https://github.com/Azure/alz-terraform-accelerator/blob/b4115bfe9e6606a06def329f9e0574bc80747c83/templates/platform_landing_zone/examples/full-multi-region/hub-and-spoke-vnet.tfvars#L226)
- Remove the security subscription line from the bootstrap configuration file if using the accelerator for a new deployment

---

### [Terraform Starter Module - v8.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v8.0.0)

- Release date: 2025-06-20
- Release link: [v8.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v8.0.0)
- Release diff: [v7.4.0...v8.0.0](https://github.com/Azure/alz-terraform-accelerator/compare/v7.4.0...v8.0.0)

This release introduces various fixes, all of which are backwards compatible.

There is one change that requires action by users, which is why we decided to flag this as a major release as we wanted to highlight this change.

ExpressRoute Gateway is rolling out a new feature called HOBO (hosted on behalf of) public ip. This feature means that the ExpressRoute Gateway will use a public IP address that is hosted on behalf of the customer, rather than requiring the customer to provide their own public IP address. At this time, there is no way for us to know which regions and subscriptions the feature has been rolled out to. As such we have introduce a new setting called `<region>_virtual_network_gateway_express_route_hobo_public_ip_enabled`. This setting is `true` by default as we believe this will suit most customers moving forward as this feature rolls out.

For existing customers, they will need to set this to `false` unless they have followed the manual migration process to upgrade their ExpressRoute Gateway to use the HOBO public IP. If a customer does not set this to `false`, they will likely see errors and idempotency issues.

For new customers in a region where the feature rolled out, they will need to ensure the setting is `true`. If they do not, they will see idempotency issues and errors when deploying / updating the ExpressRoute Gateway.

The product group has not yet announced this feature, but it has already started rolling out to customers and is impacting Terraform customers in particular. Versions of this module prior to v8.0.0 were unable to support the HOBO public IP feature as it is not supported by the azurerm provider. In this release we have migrated virtual network gateways to azapi in order to support this feature.

---

### [Terraform Starter Module - v7.4.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.4.0)

- Release date: 2025-06-13
- Release link: [v7.4.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.4.0)
- Release diff: [v7.3.2...v7.4.0](https://github.com/Azure/alz-terraform-accelerator/compare/v7.3.2...v7.4.0)

This release introduces the Azure Firewall Management IP and Associated subnet by default per our Cloud Adoption Framework (CAF) guidance. This will be on by default for new customers. However, this would be a breaking change for existing users, since it is not possible to add a management IP to an existing Azure Firewall at this time. The setting would result in a plan to destroy and recreate the Azure Firewall, which may want to be planned for a future maintenance window.

In order to support backwards compatibility we have introduced the `<region>-firewall_management_ip_enabled` setting in the configuration file. This setting is `true` by default, but can be set to `false` to avoid the management IP being created and avoid the Azure Firewall being destroyed and recreated.

---

### [Terraform Starter Module - v7.3.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.3.0)

- Release date: 2025-06-09
- Release link: [v7.3.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.3.0)
- Release diff: [v7.2.0...v7.3.0](https://github.com/Azure/alz-terraform-accelerator/compare/v7.2.0...v7.3.0)

This release introduces a default `lib` folder with predefined override and architecture files. This was introduced to improve the [Options]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options" >}}) that involve the need to turn of policies, such as AMA, DNS, and DDOS. Previously these options advised setting the policy to `DoNotEnforce`, however we found that in some cases that still result in failed deployments of spokes, due to the policy faulting even though it wasn't enforced. As such, that safest approach it to not assign the policy at all. We introduced the default `lib` archetype overrides to simplify this process for those not familiar with the modules.

- We introduced a new step to the accelerator to always setup a `lib` folder. This can be found in Phase 2, Step 5 of the [User Guide]({{< relref "accelerator/userguide" >}}) for all three VCS options.
    - [Azure DevOps]({{< relref "accelerator/userguide/2_start/terraform-azuredevops" >}})
    - [GitHub]({{< relref "accelerator/userguide/2_start/terraform-github" >}})
    - [Local]({{< relref "accelerator/userguide/2_start/terraform-local" >}})
- Updated the [Options]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options" >}}) to reference this `lib` folder and explain what needs to be uncommented in the archetype overrides:
    - [Customize Management Group Ids and Names]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options/management-groups" >}})
    - [Turn off DDoS Protection Plan]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options/ddos" >}})
    - [Turn off Private DNS zones]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options/dns" >}})
    - [Turn off a Policy Assignment]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options/policy-assignment" >}})
    - [Turn off Azure Monitoring Agent]({{< relref "accelerator/startermodules/terraform-platform-landing-zone/options/ama" >}})

In order to achieve this, we introduced a custom architecture to follow best practice for the Library setup. Previously we advised overriding the `alz` architecture for simplicity.

We also updated the default files to use YAML versions, in order make updating them a consistent approach for new accelerator users.

As a result of this, any customers with an existing `lib` folder customization attempting a diff upgrade will see additional files in lib and the new `architecture_name` setting in the config file. In order to avoid any issues, exclude these files and the `architecture_name` setting when upgrading.

If you do want to bring your `lib` folder into line with the YAML standard, you can migrate your customizations into the YAML template format and delete the old JSON file.

---

### [Terraform Starter Module - v7.2.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.2.0)

- Release date: 2025-05-06
- Release link: [v7.2.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.2.0)
- Release diff: [v7.1.0...v7.2.0](https://github.com/Azure/alz-terraform-accelerator/compare/v7.1.0...v7.2.0)

This release fixes an issue where Virtual WAN network connections were not being created for the sidecar virtual network when private DNS zones were disabled. As part of the fix the default name for these links had to be updated to match the actual use case. This will result in a plan that attempts to destroy and recreate the virtual network connections. In order to avoid this we introduced a setting called `virtual_network_connection_name` to allow overriding the name the retain the legacy name and avoid them being recreated. We have include this as a commented out setting in the configuration files for ease of use.

In order to use the legacy name, uncomment the `virtual_network_connection_name` setting in configuration file when performing your diff.

---

### [Terraform Starter Module - v7.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.0.0)

- Release date: 2025-06-02
- Release link: [v7.0.0](https://github.com/Azure/alz-terraform-accelerator/releases/tag/v7.0.0)
- Release diff: [v6.2.2...v7.0.0](https://github.com/Azure/alz-terraform-accelerator/compare/v6.2.2...v7.0.0)

This release introduces a new interface for DNS configuration. The new interface allows independent configuration of private DNS zones and private DNS resolver, including turning them on and of independently. In order to achieve this, we had to move the private DNS resolver outside of the private DNS Zones block. We also introduced the capability to supply any configuration variable to both of the underlying modules to ensure flexibility moving forward.

This resulted in the following change the example configuration files, which you will need to update to use the new version of the code:

Old:

```terraform
private_dns_zones = {
  enabled                        = "$${primary_private_dns_zones_enabled}"
  resource_group_name            = "$${dns_resource_group_name}"
  is_primary                     = true
  auto_registration_zone_enabled = "$${primary_private_dns_auto_registration_zone_enabled}"
  auto_registration_zone_name    = "$${primary_auto_registration_zone_name}.azure.local"
  subnet_address_prefix          = "$${primary_private_dns_resolver_subnet_address_prefix}"
  private_dns_resolver = {
    enabled = "$${primary_private_dns_resolver_enabled}"
    name    = "$${primary_private_dns_resolver_name}"
  }
}
```

New:

```terraform
private_dns_zones = {
  enabled = "$${primary_private_dns_zones_enabled}"
  dns_zones = {
    resource_group_name = "$${dns_resource_group_name}"
    private_link_private_dns_zones_regex_filter = {
      enabled = false
    }
  }
  auto_registration_zone_enabled = "$${primary_private_dns_auto_registration_zone_enabled}"
  auto_registration_zone_name    = "$${primary_auto_registration_zone_name}"
}
private_dns_resolver = {
  enabled               = "$${primary_private_dns_resolver_enabled}"
  subnet_address_prefix = "$${primary_private_dns_resolver_subnet_address_prefix}"
  dns_resolver = {
    name = "$${primary_private_dns_resolver_name}"
  }
}
```

---
