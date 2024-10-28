---
title: Azure Landing Zones Documentation
---

Welcome to the Azure Landing Zones technical documentation site.
This site provides guidance on how to deploy and manage Azure Landing Zones using the solutions we provide.

Use the navigation links on the left to explore the documentation.

## Definitions and Concepts

Please see our [documentation on Learn](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/) for an introduction to the concepts that we will build on here.

## The Azure Landing Zones Journey

The Azure Landing Zones journey is a multi-step process that starts with the enterprise bootstrap and ends with the deployment of workloads.

```mermaid
graph LR;
    A[Enterprise bootstrap] --> B[Azure Landing Zones platform];
    B --> C[Subscription vending];
    C --> D[Application landing zones];
    D --> E[Workloads];
```

### Enterprise bootstrap

The enterprise bootstrap is the first step in the Azure Landing Zones journey.
It is the process of setting up the foundational components that will be used to deploy and manage Azure Landing Zones.
In this step we ensure we have the correct access and some subscriptions to work with.

See the [Enterprise Bootstrap](enterprisebootstrap) section for more information.

### Azure Landing Zones platform

The Azure Landing Zones platform is the core of the Azure Landing Zones journey.
It provides the core governance, networking, security and management components that will be used to deploy and manage Azure Landing Zones.

Included in the Azure Landing Zones platform are:

- **Management groups** - used to organize subscriptions and resources.
- **Policy** - used to enforce governance and compliance.
- **Role-based access control (RBAC)** - used to control access to resources.
- **Centralized logging** - used to collect and analyze logs from Azure resources.
- **Networking** - used to provide connectivity between resources.

The reference management group and policy structure for Azure Landing Zones is published in the [Azure Landing Zones Library](https://azure.github.io/Azure-Landing-Zones-Library/).

### Subscription vending

Subscription vending is the process of automating the creation of new subscriptions for use by the organization.

To be able to automate the creation of subscriptions, you will need to have the correct permissions.
These permissions are assigned at the billing scope and the process is documented [here](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription).

### Application landing zones

Application landing zones build upon subscription vending to provide application teams with a pre-configured environment to deploy their workloads.

### Workloads

Workloads are the applications and services that are deployed into the Azure Landing Zones.

## Next steps

To get started with the Azure Landing Zones journey, let's look at the [enterprise bootstrap](enterprisebootstrap) process.
