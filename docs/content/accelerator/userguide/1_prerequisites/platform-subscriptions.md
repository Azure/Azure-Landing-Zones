---
title: Platform Subscriptions and Permissions
geekdocCollapseSection: true
weight: 5
---

This section details the prerequisites for the platform subscriptions.

## 1 - Management Group

You will need to choose the parent management group for your platform landing zone structure to sit under. This could be the `Tenant Root Group` or a new management group you create under there if preferred.

{{< hint type=warning >}}
If a parent management group other than Tenant Root Group is chosen, then you must move the 3 platform subscriptions into that management group before proceeding.
{{< /hint >}}

## 2 - Azure Subscriptions

We recommend setting up 3 subscriptions for Azure landing zones. These are management, identity and connectivity. See our [advanced scenarios]({{< relref "advancedscenarios" >}}) section for alternatives.

- Management: This is used to deploy the bootstrap and management resources, such as log analytics and automation accounts.
- Identity: This is used to deploy the identity resources, such as Azure AD and Microsoft Entra Domain Services (formerly Azure AD DS) .
- Connectivity: This is used to deploy the hub networking resources, such as virtual networks and firewalls.

You can read more about the management, identity and connectivity subscriptions in the [Landing Zone docs](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement. The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the three subscriptions following your desired naming convention.

Take note of the subscription id of each subscription as we will need them later.

## 3 - Management Group Subscription Placement

If your 3 platform subscriptions are not currently under the management group you chose in step 1, you will need to move them there. This is required for the bootstrap to work correctly.

This can be done via the [Portal](https://learn.microsoft.com/en-us/azure/governance/management-groups/manage#move-management-groups-and-subscriptions) or using the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/account/management-group/subscription?view=azure-cli-latest#az-account-management-group-subscription-add).

## 4 - Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap:

- `Owner` on your chosen parent management group.
  - `Owner` is required as this account will be granting permissions for the identities that run the management group deployment. Those identities will be granted least privilege permissions.
- `Owner` on each of your 3 Azure landing zone subscriptions.

For simplicity we recommend using a User account since this is a one off process that you are unlikely to repeat.

{{< hint type=warning >}}
Remember, if a parent management group other than Tenant Root Group is chosen, then you must move the 3 platform subscriptions into that management group before proceeding.
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
