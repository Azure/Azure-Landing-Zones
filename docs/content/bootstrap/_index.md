---
title: Getting started
weight: 10
---

Before we begin our Azure landing zone journey proper, we need some prerequisites in place.

{{< hint type=note >}}
If you are planning to use the Azure landing zone IaC Accelerator, please head over to the [Accelerator Docs]({{< relref "accelerator" >}}) now. We'll guide you through the bootstrap requirements there. If you intend to create your own modules, then you can continue to read this page.
{{< /hint >}}

## Azure Subscriptions

We recommend setting up 4 subscriptions for the Platform landing zone.

These are management, identity, connectivity, and security.

- **Management**: This is used to deploy the management resources, such as log analytics.
- **Connectivity**: This is used to deploy the hub networking resources, such as virtual networks and firewalls.
- **Identity**: This is used to deploy the identity resources, such as Active Directory and Microsoft Entra Domain Services.
- **Security**: This is used to deploy security resources, such as Azure Sentinel.

You can read more about the management, identity, connectivity,and security subscriptions in the [Azure landing zone docs](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement.
The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the four subscriptions following your desired naming convention.

Take note of the subscription id of each subscription as we will need them later.

## Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap. For simplicity, we recommend using a User account since this is a one off process that you are unlikely to repeat.

### Bicep (AVM), Bicep Classic, and Terraform all require the following permissions:

- `Owner` on your chosen parent management group.
  - `Owner` is required because this account grants permissions to the identities that run the management group deployment. Those identities are granted only the permissions they need.
- `Owner` on each of your 4 Azure landing zone subscriptions.

### Bicep (AVM) has one additional requirement:

- `User Access Administrator` at that root `/` level.
  - `User Access Administrator` is required for the same reason: this account delegates access to the identities that run the management group deployment using least privilege.

Follow the instructions in the [Root Access]({{< relref "/accelerator/1_prerequisites/root-access" >}}) section if you need to assign this permission.

{{< hint type=info >}}
Access at the root is currently required due to a bug within ARM, and is being investigated by Microsoft.
{{< /hint >}}

## Next Steps

Now choose your next step!

The ALZ IaC Accelerator allows you to quickly get started with IaC and DevOps best practices for Azure landing zone.

It supports both Terraform and Bicep:

- [**ALZ IaC accelerator**]({{< relref "accelerator" >}}) (recommended) - This is the recommended approach for most customers. It provides a streamlined experience with built-in best practices and CI/CD pipelines to get you up and running quickly.
- [**Portal accelerator**]({{< relref "portal" >}}) - It provides an Azure Portal based experience for deploying the new modules.


You can also opt to use Bicep and Terraform directly:

- [**Bicep**]({{< relref "bicep" >}})
- [**Terraform**]({{< relref "terraform" >}})
