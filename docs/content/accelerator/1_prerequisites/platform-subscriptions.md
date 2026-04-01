---
title: Platform Subscriptions and Permissions
geekdocCollapseSection: true
weight: 5
---

This section details the prerequisites for the platform subscriptions.

## 1 - Management Group

You will need to choose the parent management group for your Platform landing zone structure to sit under. This could be the `Tenant Root Group` or a new management group you create under there if preferred.

## 2 - Azure Subscriptions

{{< hint type=tip >}}
**Recommended: 4 subscriptions.** We strongly recommend setting up all 4 platform subscriptions for a complete and well-architected landing zone. Migrating resources between subscriptions can be a complex and time-consuming process and not it is not supported for all resource types. See [here](https://learn.microsoft.com/azure/azure-resource-manager/management/move-resources-overview) for more details. 
{{< /hint >}}

The 4 recommended platform subscriptions are:

- **Management** (required): This is used to deploy the bootstrap and management resources, such as log analytics and automation accounts.
- **Connectivity** (required): This is used to deploy the hub networking resources, such as virtual networks and firewalls.
- **Identity** (recommended): This is used to deploy the identity resources, such as Azure AD and Microsoft Entra Domain Services.
- **Security** (recommended): This is used to deploy Sentinel and other security related resources.

You can read more about the management, identity, connectivity, and security subscriptions in the [Landing Zone docs](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

{{< hint type=warning >}}
**SMB (Small-Medium Business) minimum: 2 subscriptions.** If you are a small business that has not yet scaled and you are using one of the [SMB scenarios]({{< relref "../../accelerator/starter-terraform/scenarios#smb-small-medium-business-scenarios" >}}), you can start with just the **Management** and **Connectivity** subscriptions. The Identity and Security subscription placements are commented out in the SMB configuration files and can be enabled later.

**Important:** This is only a starting point. As your organization grows, you **will** need to add dedicated Identity and Security subscriptions. Plan for this from the outset.
{{< /hint >}}

To create the subscriptions you will need access to a billing agreement. The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the subscriptions following your desired naming convention.

**For the recommended 4-subscription model:** Create all four subscriptions (Management, Connectivity, Identity, Security).

**For the SMB 2-subscription model:** Create the Management and Connectivity subscriptions. You will add Identity and Security subscriptions later as your organization scales.

Take note of the subscription id of each subscription as we will need them later.

## 3 - Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap. For simplicity, we recommend using a User account since this is a one off process that you are unlikely to repeat.

### Bicep and Terraform both require the following permissions:

- `Owner` on your chosen parent management group.
  - `Owner` is required because this account grants permissions to the identities that run the management group deployment. Those identities are granted only the permissions they need.
- `Owner` on each of your platform landing zone subscriptions (4 for standard deployments, or 2 for SMB deployments).

### Bicep has one additional requirement:

- `User Access Administrator` at that root `/` level.
  - `User Access Administrator` is required for the same reason: this account delegates access to the identities that run the management group deployment using least privilege.

Follow the instructions in the [Root Access]({{< relref "root-access" >}}) section if you need to assign this permission.

{{< hint type=info >}}
Access at the root is currently required due to a bug within ARM, and is being investigated by Microsoft.
{{< /hint >}}

### Authenticate via User Account

1. Open a new PowerShell Core (pwsh) terminal.
1. Run `az login`.
1. You'll be redirected to a browser to login, perform MFA, etc.
1. Find the subscription id of the management subscription you made a note of earlier.
1. Type `az account set --subscription "<subscription id of your management subscription>"` and hit enter.
1. Type `az account show` and verify that you are connected to the management subscription.

### Authenticate via Service Principal (Skip this if using a User account)

Follow the instructions in the [Service Principal]({{< relref "service-principal" >}}) section.
