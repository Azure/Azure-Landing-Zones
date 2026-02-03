---
title: Extra Policies and Information
weight: 7
---

This document describes additional ALZ custom policy definitions and initiatives that are not assigned by default in ALZ, but are provided as they may assist some consumers of ALZ in specific scenarios where they can assign these additional policies to help them meet their objectives. We also provide guidance on how to handle certain situations as some of the policies require additional considerations prior to assigning.

> For the complete list of Azure Landing Zones custom policies, please use [AzAdvertizer](https://www.azadvertizer.net/azpolicyadvertizer_all.html), and change `type` to `ALZ`.

## Additional ALZ Custom Policies for consideration

ALZ provides several additional policies that are not assigned by default but that can be used for specific scenarios should they be required.

| Policy | Description | Notes |
|------------|-------------|-------------|
| Audit-Tags-Mandatory | Audit for mandatory tags on resources | Audits resources to ensure they have required tags based on tag array. Does not apply to resource groups. |
| Audit-Tags-Mandatory-RG | Audit for mandatory tags on resource groups | Audits resource groups to ensure they have required tags based on tag array. |
| Deny-Appgw-Without-Waf | Application Gateway should be deployed with WAF enabled | Use to ensure Application Gateways are deployed with Web Application Firewall enabled |
| Deny-Private-Dns-Zones | Deny the creation of private DNS | For organizations that centralize core networking functions, use this policy to prevent the creation of additional Private DNS Zones under specific scopes |
| Deny-Subnet-Without-Penp | Subnets without Private Endpoint Network Policies enabled should be denied | This policy denies the creation of a subnet without Private Endpoint Network Policies enabled. This policy is intended for 'workload' subnets, not 'central infrastructure' (aka, 'hub') subnets. |
| Deny-Subnet-Without-Udr | Subnets should have a User Defined Route | Should you require all network traffic be directed to an appliance for inspection, you can use this policy to ensure UDR is associated with a subnet |
| Deny-Udr-With-Specific-Nexthop | User Defined Routes with 'Next Hop Type' set to 'Internet' or 'VirtualNetworkGateway' should be denied | Refining `Deny-Subnet-Without-Udr` you can ensure non-compliant UDRs are denied (e.g., bypassing a firewall) |
| Deny-Vnet-Peering | Deny vNet peering | Use to prevent vNet peering under specific scopes (e.g., Sandbox management group) |
| Deny-Vnet-Peering-To-Non-Approved-Vnets | Deny vNet peering to non-approved vNets | Use to control vNet peering under specific scopes, like in the Corp management group, only allow peering to the hub vNet. |
| Deploy-Budget | Deploy a default budget on all subscriptions under the assigned scope | Set a default budget for a specific scope, like setting a $500 budget on all subscriptions in the Sandbox management group |
|Deploy-Sql-Security_20240529| Deploy-SQL Database built-in SQL security configuration| Deploy auditing, Alert, TDE and SQL vulnerability to SQL Databases when it not exist in the deployment|
| Deploy-Vnet-Hubspoke | Deploy Virtual Network with peering to the hub | Automatically peer a new virtual network with the hub, for example, in the Corp management group |
| Deploy-Windows-DomainJoin | Deploy Windows Domain Join Extension with Key Vault configuration | Windows Domain Join a virtual machine using domain name and password stored in Key Vault as secrets |

## 2. ALZ, Workload Specific Compliance (WSC) and Regulated Industries

The Azure Landing Zone is designed to be a flexible and scalable solution that can be used by organizations in a variety of industries. However, organizations in regulated industries (FSI, Healthcare, etc.) may need to take additional steps to ensure compliance with industry-specific regulations. These regulations often commonly have a consistent set of controls to cover, like CMK, locking down public endpoints, TLS version enforcement, logging etc.

To support the additional control requirements of these industries, we're providing the following additional initiatives that enhance the security and compliance posture of the Azure Landing Zone:

> **Please Note:** These are meant to help customers across all regulated industries (FSI, Healthcare, etc.) and not be aligned to specific regulatory controls, as there are already policy initiatives available for these via [Azure Policy](https://learn.microsoft.com/azure/azure-resource-manager/management/security-controls-policy) & [Microsoft Defender for Cloud](https://learn.microsoft.com/azure/defender-for-cloud/regulatory-compliance-dashboard)

{{< hint type=note >}}
The below table is scrollable. On smaller screens, please scroll horizontally to view all columns.
{{< /hint >}}

{{< csv-table file="data/ALZWorkloadAssignments.csv" >}}
