---
title: Terraform - Sovereign Landing Zone
resources:
  - name: microsoft_cloud_for_sovereignty
    src: img/microsoft_cloud_for_sovereignty.png
    alt: A process flow showing the areas covered by the Azure landing zones Terraform accelerator.
    title: Sovereign Landing Zone Starter Module
---

The `sovereign_landing_zone` starter module provides full customization of the Sovereign Landing Zone (SLZ) using the `inputs.yaml` file. The `inputs.yaml` file provides the ability to enable and disable modules, configure module inputs and outputs, and configure module resources.
A custom `inputs.yaml` file can be passed to the `inputs` argument of the ALZ PowerShell Module(version [4.1.5](https://www.powershellgallery.com/packages/ALZ/4.1.5) should be used). This allows you to firstly design your Azure Landing Zone, and then deploy it.

The default `inputs.yaml` file will need to be modified based on the documentation below.

Example input files can be found here:

- [inputs-azure-devops.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/microsoft_cloud_for_industry/sovereign_landing_zone/examples/bootstrap/inputs-azure-devops.yaml)
- [inputs-github.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/microsoft_cloud_for_industry/sovereign_landing_zone/examples/bootstrap/inputs-github.yaml)
- [inputs-local.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/microsoft_cloud_for_industry/sovereign_landing_zone/examples/bootstrap/inputs-local.yaml)

The following table describes the inputs for the `sovereign_landing_zone` starter module.

| Input | Required | Type | Default Value | Description |
| - | -- | --- | ---- | ----- |
| `allowed_locations` | Required | List |  | This is a list of Azure regions all workloads running outside of the Confidential Management Group scopes are allowed to be deployed into. |
| `allowed_locations_for_confidential_computing` | Required | List |  | This is a list of Azure regions all workloads running inside of the Confidential Management Group scopes are allowed to be deployed into. |
| `az_firewall_policies_enabled` |  | Boolean | `true` | Set to `true` to deploy a default Azure Firewall Policy resource if `enable_firewall` is also `true`. |
| `apply_alz_archetypes_via_architecture_definition_template` |  | Boolean | `true` | This controls whether to apply the ALZ archetypes (policy assignments) to the SLZ deployment. |
| `bastion_outbound_ssh_rdp_ports` |  | List | `["22", "3389"]` | List of outbound remote access ports to enable on the Azure Bastion NSG if `deploy_bastion` is also `true`. |
| `custom_subnets` |  | Map | See `inputs.yaml` for default object. | Map of subnets and their configurations to create within the hub network. |
| `customer` |  | String | `"Country/Region"` | Customer name to use when branding the compliance dashboard. |
| `optional_postfix` |  | String |  | Postfix value to append to all resources. |
| `default_prefix` | Required | String | `slz` | Prefix value to append to all resources. |
| `default_security_groups` |  | List |  | Array of default security groups. Defaults to an empty array. |
| `deploy_bastion` |  | Boolean | `true` | Set to `true` to deploy Azure Bastion within the hub network. |
| `deploy_bootstrap` |  | Boolean | `true` | Set to `true` to deploy bootstrap module. |
| `deploy_dashboard` |  | Boolean | `true` | Set to `true` to deploy dashboard module. |
| `deploy_ddos_protection` |  | Boolean | `true` | Set to `true` to deploy Azure DDoS Protection within the hub network. |
| `deploy_hub_network` |  | Boolean | `true` | Set to `true` to deploy the hub network. |
| `deploy_log_analytics_workspace` |  | Boolean | `true` | Set to `true` to deploy Azure Log Analytics Workspace. |
| `deploy_platform` |  | Boolean | `true` | Set to `true` to deploy platform module. |
| `enable_firewall` |  | Boolean | `true` | Set to `true` to deploy Azure Firewall within the hub network. |
| `enable_telemetry` |  | Boolean | `true` | Set to `false` to opt out of telemetry tracking. We use telemetry data to understand usage rates to help prioritize future development efforts. |
| `express_route_gateway_config` |  | Map | `{name: "noconfigEr"}` | Leave as default to not deploy an ExpressRoute Gateway. See the Network Connectivity section below for details. |
| `hub_network_address_prefix` |  | CIDR | "10.20.0.0/16" | This is the CIDR to use for the hub network. |
| `landing_zone_management_group_children` |  | Map |  | See the Customize Application Platform/Landing Zones section below for details. |
| `log_analytics_workspace_retention_in_days` |  | Numeric | 365 | Number of days to retain logs in the Log Analytics Workspace. |
| `log_analytics_workspace_resource_id` |  | String |  | The resource ID of the Log Analytics workspace to use for the deployment. |
| `management_group_configuration` |  | Object |  | See the Customize Management Group Configuration section below for details. |
| `ms_defender_for_cloud_email_security_contact` |  | Email | `security_contact@replaceme.com` | Email address to use for Microsoft Defender for Cloud. |
| `platform_management_group_children` |  | Map |  | See the Customize Application Platform/Landing Zones section below for details. |
| `policy_effect` |  | String | `Deny` | The effect to use for the Sovereign Baseline Policy initiatives, when policies support multiple effects. |
| `policy_exemptions` |  | Map | See the Custom Compliance section below for details. | Map of customer specified policy exemptions to use alongside the SLZ. |
| `tags` |  | Map | See the Custom Tagging section below for details. | Set of tags to apply to all resources deployed. |
| `use_premium_firewall` |  | Boolean | `true` | Set to `true` to deploy Premium SKU of the Azure Firewall if `enable_firewall` is also `true`. |
| `vpn_gateway_config` |  | Map | `{name: "noconfigEr"}` | Leave as default to not deploy an VPN Gateway. See the Network Connectivity section below for details. |

### Policy Exemptions

An example of the format for the `policy_exemptions` map is as follows:

```yaml
policy_exemptions: {
  policy_exemption1: {
    name: "globalexemption",
    display_name: "global",
    description: "test",
    management_group_id: "/providers/Microsoft.management/managementGroups/<MG-ID-SCOPE>",
    policy_assignment_id: "/providers/microsoft.management/managementGroups/<MG-ID-SCOPE>/providers/microsoft.Authorization/policyassignments/enforce-sovereign-global",
    policy_definition_reference_ids: ["AllowedLocations"]
  }
}
```

## Customize Management Group Configuration

### Default Management Group Configuration

NOTE - management_group_configuration archetypes array can be used for including non-ALZ archetypes.
ALZ archetypes can be toggled using input variable apply_alz_archetypes_via_architecture_definition_template.

All archetypes(ALZ/SLZ) can be found [here](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/slz/README.md).

The default format for the `management_group_configuration` map is as follows:

```yaml
management_group_configuration: {
  root: {
    id: "${default_prefix}${optional_postfix}",
    display_name: "Sovereign Landing Zone",
    archetypes: ["global"]
  },
  platform: {
    id: "${default_prefix}-platform${optional_postfix}",
    display_name: "Platform",
    archetypes: []
  },
  landingzones: {
    id: "${default_prefix}-landingzones${optional_postfix}",
    display_name: "Landing Zones",
    archetypes: []
  },
  decommissioned: {
    id: "${default_prefix}-decommissioned${optional_postfix}",
    display_name: "Decommissioned",
    archetypes: []
  },
  sandbox: {
    id: "${default_prefix}-sandbox${optional_postfix}",
    display_name: "Sandbox",
    archetypes: []
  },
  management: {
    id: "${default_prefix}-platform-management${optional_postfix}",
    display_name: "Management",
    archetypes: []
  },
  connectivity: {
    id: "${default_prefix}-platform-connectivity${optional_postfix}",
    display_name: "Connectivity",
    archetypes: []
  },
  identity: {
    id: "${default_prefix}-platform-identity${optional_postfix}",
    display_name: "Identity",
    archetypes: []
  },
  corp: {
    id: "${default_prefix}-landingzones-corp${optional_postfix}",
    display_name: "Corp",
    archetypes: []
  },
  online: {
    id: "${default_prefix}-landingzones-online${optional_postfix}",
    display_name: "Online",
    archetypes: []
  },
  confidential_corp: {
    id: "${default_prefix}-landingzones-confidential-corp${optional_postfix}",
    display_name: "Confidential Corp",
    archetypes: ["confidential"]
  },
  confidential_online: {
    id: "${default_prefix}-landingzones-confidential-online${optional_postfix}",
    display_name: "Confidential Online",
    archetypes: ["confidential"]
  }
}
```

## Customize Application Platform/Landing Zones

### Landing Zone Management Group Children

An example of the format for the `landing_zone_management_group_children` map is as follows:

```yaml
landing_zone_management_group_children: {
  child1: {
      id: "${default_prefix}-landingzones-child1${optional_postfix}",
      display_name: "Landing zone child one",
      archetypes: []
  }
}
```

### Platform Management Group Children

An example of the format for the `platform_management_group_children` map is as follows:

```yaml
platform_management_group_children: {
    security: {
      id: "${default_prefix}-platform-security${optional_postfix}",
      display_name: "Security",
      archetypes: ["confidential"]
  }
}
```

## Custom Tagging

### Tags

An example of the format for the `tags` map is as follows:

```yaml
tags: {
  Environment: "Production",
  ServiceName: "SLZ"
}
```

## Network Connectivity

### ExpressRoute Gateway Config

An example of the format for the `express_route_gateway_config` map is as follows:

```yaml
express_route_gateway_config: {
  name: "express_route",
  gatewayType: "ExpressRoute",
  sku: "ErGw1AZ",
  vpnType: "RouteBased",
  vpnGatewayGeneration: null,
  enableBgp: false,
  activeActive: false,
  enableBgpRouteTranslationForNat: false,
  enableDnsForwarding: false,
  asn: 65515,
  bgpPeeringAddress: "",
  peerWeight: 5
}
```

### VPN Gateway Config

An example of the format for the `vpn_gateway_config` map is as follows:

```yaml
vpn_gateway_config: {
  name: "vpn_gateway",
  gatewayType: "Vpn",
  sku: "VpnGw1",
  vpnType: "RouteBased",
  vpnGatewayGeneration: "Generation1",
  enableBgp: false,
  activeActive: false,
  enableBgpRouteTranslationForNat: false,
  enableDnsForwarding: false,
  bgpPeeringAddress: "",
  asn: 65515,
  peerWeight: 5,
  vpnClientConfiguration: {
    vpnAddressSpace: ["10.2.0.0/24"]
  }
}
```

## Known Issues

The following are known issues with the Public Preview release for the SLZ.

### Multiple Inputs for Location

The inputs for `bootstrap_location` and `starter_locations` must be identical, using the first region in starter_locations as the default location. Therefore, starter_locations is required and must include at least one region. In a future release, we will have defaults and overrides for these values.

### Terraform Plan or Apply Fails After Updating tfvars

Any updates should be made to the `inputs.yaml` file and the tfvars will be updated upon executing the `Deploy-Accelerator` PowerShell command.

### Invalid Hub Network Address Prefix or Subnet Address Prefix

There is no validation done to ensure subnets fall within the hub network CIDR or that subnets do not overlap. These issues will be uncovered during apply.

### Unable to update the bastion subnet

Workaround:
Set deploy_bastion= false in inputs file
Run deployAccelerator command
Run .\scripts\deploy-local.ps1
Set deploy_bastion= true in inputs file, update AzureBastionSubnet address_prefix
Run deployAccelerator command
Run .\scripts\deploy-local.ps1

### Unable to update the firewall subnet

Work around:
Set deploy_bastion= false and enable_firewall = false in inputs file
Run deployAccelerator command
Run .\scripts\deploy-local.ps1
Set deploy_bastion= true and enable_firewall = true in inputs file, update AzureFirewallSubnet address_prefix
Run deployAccelerator command

### Tags are Not Applied to All Resources

Certain resources are not receiving the default tags. This will be addressed in a future release.

### Default Compliance Score is not 100%

Certain resources will show as being out of compliance by default. This will be addressed in a future release.

## Notes about Policy Remediations

1. Policy Definition [migrateToMdeTvm](/providers/Microsoft.Authorization/policyDefinitions/766e621d-ba95-4e43-a6f2-e945db3d7888) will be excluded from remediation as customers must [enable MDFC](https://learn.microsoft.com/en-us/azure/defender-for-cloud/connect-azure-subscription?WT.mc_id=Portal-HubsExtension) on their subscriptions for this policy and then run remediation via Azure portal.

2. Log analytics polices deploy-diag-logscat and deploy-azactivity-log will be skipped for remediation until customer has set the log_analytics_workspace_resource_id(output after successful deployment of LZ) input and re-run deploy-accelerator/deploy-local.ps1.

3. Updating assignment policies or management group configuration will trigger recreation of azapi policy remediation resources -
Because customers have the option to include custom policies with built-in policy set definitions, and remediations require the policyReferenceId for policy definitions in policy sets, the policyReferenceId must be queried dynamically and due to Terraform's limitations on creating resources in a for_each, remediations will get recreated as the result of a workaround for allowing this dynamic query.
Remediation tasks will only be created if a policy is not in compliance.

There is an experimental feature that would allow the dynamic creation of resources in a for_each, but work on this is on-going.

## Notes running on non-global admin service principal

To deploy with lowered permissions using a service principal with "Owner" role assignment at the tenant root management group, set the following environment variable in powershell:

```powershell
$env:AZAPI_RETRY_GET_AFTER_PUT_MAX_TIME="30m"
```

## Notes on required permissions for optional security group creation

The following permissions are needed for [security group creation](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)

Security group creation can be disabled by setting input `management_security_groups = []`. Also, security groups in management_security_groups are case-sensitive.

## Instructions for using custom policies and updating parameter values for ALZ or SLZ policies

Custom policies can be added to the `lib` directory in the root of the starter module. Here is an example in the [AVM terraform-azurerm-avm-ptn-alz](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/tree/main/examples/policy-assignment-modification-with-custom-lib/lib) repo.

NOTE - Customers can also include custom [policy set definition](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/fsi/policy_set_definitions/SO-01-Data-Residency.alz_policy_set_definition.json) and [policy definition](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/policy_definitions/Append-AppService-latestTLS.alz_policy_definition.json) ARM templates into the `lib` directory.
File names must contain the same format as in the given examples.

Customers can also update policy parameter values for ALZ or SLZ policies by including an updated copy of the policy file in the `lib` directory. The new file will overwrite the existing policy file in the module. The new file must contain the same format as the original policy file.

## Instructions updating policy default values

In the starter module locals.tf, customers can update the slz_policy_default_values for any of the parameters set in this [example](https://github.com/Azure/terraform-azurerm-avm-ptn-alz/blob/main/examples/management/main.tf#L43C4-L50).

```terraform
slz_policy_default_values = {
  slz_policy_effect                            = jsonencode({ value = var.policy_effect })
  list_of_allowed_locations                    = jsonencode({ value = var.allowed_locations })
  allowed_locations_for_confidential_computing = jsonencode({ value = var.allowed_locations_for_confidential_computing })
  ddos_protection_plan_id                      = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.Network/ddosProtectionPlans/placeholder" })
  ddos_protection_plan_effect                  = jsonencode({ value = var.deploy_ddos_protection ? "Audit" : "Disabled" })
  email_security_contact                       = jsonencode({ value = var.ms_defender_for_cloud_email_security_contact })
  ama_user_assigned_managed_identity_id        = jsonencode({ value = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/placeholder/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.uami_name}" })
  ama_user_assigned_managed_identity_name      = jsonencode({ value = local.uami_name })
  log_analytics_workspace_id                   = jsonencode({ value = var.log_analytics_workspace_resource_id })
}
```

## Further details on the Sovereign Landing Zone Starter Module

The Terraform-based deployment for the Sovereign Landing Zone (SLZ) provides an Enterprise Scale Landing Zone with equivalent compliance posture equal to that of our [Bicep implementation][bicep_implementation_slz]. There is not currently a migration path between the two implementations, however multiple landing zones can be created with either deployment technology in the same Azure tenant.

### High Level Design

{{< img name="microsoft_cloud_for_sovereignty" size="origin" lazy=true >}}

### Terraform Modules

#### `alz-archetypes` and `slz-archetypes`

The `alz-archetypes` and `slz-archetypes` are different from Terraform modules, but are used to deploy the management group hierarchy, policy assignments and management resources including the sovereign baseline policies. For more information on the archetypes, view the [ALZ archetypes](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/alz/) and the [SLZ archetypes](https://github.com/Azure/Azure-Landing-Zones-Library/blob/main/platform/slz/).

#### `subscription-vending`

The `subscription-vending` module is used to deploy the subscriptions and move them within the right management group scopes. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-lz-vending/tree/main/modules/subscription).

#### `hubnetworking`

The `hubnetworking` module is used to deploy the hub VNET, Azure Firewall , Route Tables, and other networking primitives into the connectivity subscription. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-ptn-hubnetworking).

#### `private-link`

The `private-link` module is used to deploy default private link private DNS Zones. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-ptn-network-private-link-private-dns-zones).

#### `alz-management`

The `alz-management` module is used to deploy a set of management resources such as those for centralized logging. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-ptn-alz-management).

#### `resource-group`

The `resource-group` module is used to deploy a variety of resource groups within the default subscriptions. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-resources-resourcegroup).

#### `portal-dashboard`

The `portal-dashboard` module is used to deploy the default compliance dashboard. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-portal-dashboard).

#### `azure-bastion`

The `azure-bastion` module is used to deploy Azure Bastion for remote access. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-network-bastionhost).

#### `firewall-policy`

The `firewall-policy` module is used to deploy a default Azure Firewall Policy for further configuration. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-network-firewallpolicy).

#### `ddos-protection`

The `ddos-protection` module is used to deploy a Standard SKU DDoS Protection Plan resource for network security. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-network-ddosprotectionplan).

#### `public-ip`

The `public-ip` module is used to deploy a Azure Public IP resoures for offerings that need inbound public internet access such as the VPN and ExpressRoute Gateways. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-network-publicipaddress).

#### `networksecuritygroup`

The `networksecuritygroup` module is used to deploy a default NSG for the Azure Bastion subnet to restrict ingress and egress network access. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-avm-res-network-networksecuritygroup).

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[example_powershell_inputs_azure_devops_terraform_sovereign_landing_zone]:               examples/powershell-inputs/inputs-azure-devops-terraform-sovereign-landing-zone.yaml "Example - PowerShell Inputs - Devops - Terraform - Sovereign Landing Zone"
[example_powershell_inputs_github_terraform_sovereign_landing_zone]:               examples/powershell-inputs/inputs-github-terraform-sovereign-landing-zone.yaml "Example - PowerShell Inputs - Local - Terraform - Sovereign Landing Zone"
[example_powershell_inputs_local_terraform_sovereign_landing_zone]:               examples/powershell-inputs/inputs-local-terraform-sovereign-landing-zone.yaml "Example - PowerShell Inputs - Local - Terraform - Sovereign Landing Zone"
[bicep_implementation_slz]:                                    https://aka.ms/slz/bicep "Sovereign Landing Zone (Bicep)"
