---
title: Bootstrap
weight: 10
---

Before we begin our Azure Landing Zones journey proper, we need some prerequisites in place.

## Azure Subscriptions

We recommend setting up 3 subscriptions for Azure landing zones.
These are management, identity and connectivity.

- **Management**: This is used to deploy the bootstrap and management resources, such as log analytics and automation accounts.
- **Connectivity**: This is used to deploy the hub networking resources, such as virtual networks and firewalls.
- **Identity**: (Optional) This is used to deploy the identity resources, such as Azure AD and Azure AD Domain Services. You will not need this if you do not have any AD-DS or [Entra Domain Services](https://azure.microsoft.com/products/microsoft-entra-ds) requirements.

You can read more about the management, identity and connectivity subscriptions in the [Landing Zone docs](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement.
The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the three subscriptions following your desired naming convention.

Take note of the subscription id of each subscription as we will need them later.

## Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap:

- `Owner` on your chosen parent management group for the Azure landing zone. This could be `Tenant Root Group` or a new management group you create under there if preferred.
  - Owner is required as this account will be granting permissions for the identities that run the management group deployment. Those identities will be granted least privilege permissions.
- `Owner` on each of your Azure landing zone subscriptions.

## Next Steps

Now choose your next step!

The Accelerator allows you to quickly get started with IaC and DevOps best practices for Azure Landing Zones.
It supports both Terraform and Bicep:

- [**Accelerator**]({{< relref "accelerator/userguide" >}})

You can also opt to use Bicep and Terraform directly:

- [**Bicep**]({{< relref "bicep" >}})
- [**Terraform**]({{< relref "terraform" >}})
