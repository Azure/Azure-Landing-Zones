---
title: Accelerator
geekdocCollapseSection: true
weight: 20
resources:
  - name: components
    src: img/components.png
    title: Components
  - name: overview
    src: img/alz-terraform-accelerator.png
    title: Overview
---

Welcome to the Azure landing zone IaC Accelerator for Bicep and Terraform!

The Azure Verified Modules for Platform landing zone (ALZ) [Terraform](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone) and [Bicep](https://github.com/Azure/alz-bicep-accelerator/tree/main/templates) modules provide an opinionated approach for deploying and managing the core platform capabilities of [Azure landing zone architecture](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-architecture) using Bicep or Terraform.

## Get Started

Head to the relevant section to get started:

- [0 - Planning]({{< relref "0_planning" >}}) - Skip this if you already know what you want to deploy
- [1 - Prerequisites]({{< relref "1_prerequisites" >}})
- [2 - Bootstrap]({{< relref "2_bootstrap" >}})
- [3 - Run]({{< relref "3_run" >}})

## Supported Version Control Systems (VCS)

The accelerator supports both Azure DevOps and GitHub. We are only able to support the hosted versions of these services.

If you are using self-hosted versions of these services or another VCS, you can still use the accelerator to produce the landing zone code by using the `alz_local` bootstrap module, but you will need to configure the VCS manually or with your own automation.

## Accelerator features

The accelerator bootstraps a continuous delivery environment for you. It supports both the Azure DevOps and GitHub version control system (VCS). It uses the [ALZ PowerShell module](https://www.powershellgallery.com/packages/ALZ) to gather required user input and apply a Terraform module to configure the bootstrap environment.

{{< hint type=note >}}
For Bicep users, the accelerator uses Terraform to bootstrap the environment only. Bicep is used to deploy and update the Platform landing zone.
{{< /hint >}}

The accelerator follows a 3 phase approach:

1. Prerequisites: Instructions to configure credentials and subscriptions.
2. Bootstrap: Run the PowerShell module to generate the continuous delivery environment.
3. Run: Update the module (if needed) to suit the needs of your organization and deploy via continuous delivery.

{{< img name="overview" size="origin" lazy=true >}}

The components of the environment are similar, but differ depending on your choice of VCS:

{{< img name="components" size="origin" lazy=true >}}

### GitHub

- Azure:
  - Resource Group for State (Terraform only)
  - Storage Account and Container for State (Terraform only)
  - Resource Group for Identity
  - User Assigned Managed Identities (UAMI) with Federated Credentials for Plan and Apply
  - Permissions for the UAMI on state storage container, subscriptions and management groups
  - [Optional] Container Registry for GitHub Runner image
  - [Optional] Container Instances hosting GitHub Runners
  - [Optional] Virtual network, subnets, private DNS zone and private endpoint.

- GitHub
  - Repository for the Module
  - Repository for the Action Templates
  - Starter Terraform module with tfvars
  - Branch policy
  - Action for Continuous Integration
  - Action for Continuous Delivery
  - Environment for Plan
  - Environment for Apply
  - Action Variables for Backend and Plan / Apply
  - Team and Members for Apply Approval
  - Customized OIDC Token Subject for governed Actions
  - [Optional] Runner Group

### Azure DevOps

- Azure:
  - Resource Group for State (Terraform only)
  - Storage Account and Container for State (Terraform only)
  - Resource Group for Identity
  - User Assigned Managed Identities (UAMI) with Federated Credentials for Plan and Apply
  - Permissions for the UAMI on state storage container, subscriptions and management groups
  - [Optional] Container Registry for Azure DevOps Agent image
  - [Optional] Container Instances hosting Azure DevOps Agents
  - [Optional] Virtual network, subnets, private DNS zone and private endpoint.

- Azure DevOps
  - Project (can be supplied or created)
  - Repository for the Module
  - Repository for the Pipeline Templates
  - Starter Terraform module with tfvars
  - Branch policy
  - Pipeline for Continuous Integration
  - Pipeline for Continuous Delivery
  - Environment for Plan
  - Environment for Apply
  - Variable Group for Backend
  - Service Connections with Workload identity federation for Plan and Apply
  - Service Connection Approvals, Template Validation and Concurrency Control
  - Group and Members for Apply Approval
  - [Optional] Agent Pool

### Local File System

This outputs the ALZ module files to the file system, so you can apply them manually or with your own VCS / automation.

- Azure:
  - Resource Group for State (Terraform only)
  - Storage Account and Container for State (Terraform only)
  - Resource Group for Identity
  - User Assigned Managed Identities (UAMI) for Plan and Apply
  - Permissions for the UAMI on state storage container, subscriptions and management groups

- Local File System
  - Starter module with variables

## Azure landing zone

The following diagram and links detail the Platform landing zone, but you can learn a lot more about Azure landing zone [here](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/).

![Azure landing zone reference architecture](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/media/ns-arch-cust-expanded.svg)
