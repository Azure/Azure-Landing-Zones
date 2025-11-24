---
title: Bootstrap
weight: 10
---

Before we begin our Azure Landing Zones journey proper, we need some prerequisites in place.

{{< hint type=note >}}
If you are planning to use the Azure Landing Zones IaC Accelerator, please head over to the [Accelerator Docs]({{< relref "accelerator" >}}) now. We'll guide you through the bootstrap requirements there. If you intend to create your own modules, then you can continue to read this page.
{{< /hint >}}

## Azure Subscriptions

We recommend setting up 4 subscriptions for the Platform Landing Zone.

These are management, identity, connectivity, and security.

- **Management**: This is used to deploy the management resources, such as log analytics.
- **Connectivity**: This is used to deploy the hub networking resources, such as virtual networks and firewalls.
- **Identity**: This is used to deploy the identity resources, such as Active Directory and Microsoft Entra Domain Services.
- **Security**: This is used to deploy security resources, such as Azure Sentinel.

You can read more about the management, identity, connectivity,and security subscriptions in the [Azure Landing Zones docs](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement.
The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the four subscriptions following your desired naming convention.

Take note of the subscription id of each subscription as we will need them later.

## Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap:

- `Owner` on your chosen parent management group for the Platform Landing Zone. This could be `Tenant Root Group` or a new management group you create under there if preferred.
    - Owner is required as this account will be granting permissions for the identities that run the management group deployment. Those identities will be granted least privilege permissions.
- `Owner` on each of your Platform Landing Zone subscriptions.

## Next Steps

Now choose your next step!

The ALZ IaC Accelerator allows you to quickly get started with IaC and DevOps best practices for Azure Landing Zones.

It supports both Terraform and Bicep:

- [**ALZ IaC Accelerator**]({{< relref "accelerator" >}})

You can also opt to use Bicep and Terraform directly:

- [**Bicep**]({{< relref "bicep" >}})
- [**Terraform**]({{< relref "terraform" >}})
