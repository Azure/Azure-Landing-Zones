---
title: User Guide
geekdocCollapseSection: true
weight: 5
resources:
  - name: alz-accelerator-overview
    src: img/alz-terraform-accelerator.png
    alt: A process flow showing the areas covered by the Azure landing zones Terraform accelerator.
    title: ALZ Accelerator Overview
---

## Quick Start

For the majority of users, this is the place to start. The quick start is a step by step guide to get your Azure Landing Zone environment up and running.

Now head to [Get Started](#get-started).

## Advanced Users

For those users with very specific requirements we provide some advanced capabilities that allow you to override some of the defaults.

See our [FAQ]({{< relref "../faq" >}}) and [Advanced Scenarios]({{< relref "advancedscenarios" >}}) for more info.

## Get Started

This guide takes you through the steps to prepare your prerequisites and then run the PowerShell module.

The accelerator bootstraps a continuous delivery environment for you. It supports both the Azure DevOps and GitHub version control system (VCS). It uses the [ALZ PowerShell module](https://www.powershellgallery.com/packages/ALZ) to gather required user input and apply a Terraform module to configure the bootstrap environment.

The accelerator quick start follows a 3 phase approach, with an optional planning and decisions phase:

{{< hint type=tip >}}
If this is your first time running the accelerator, we recommend starting with [phase 0]({{< relref "0_planning" >}}) to make some decisions and get a better understanding before you start.
{{< /hint >}}

- [Phase 0]({{< relref "0_planning" >}}): Planning and decisions to make before starting.
- [Phase 1]({{< relref "1_prerequisites" >}}): Instructions to configure credentials and subscriptions.
- [Phase 2]({{< relref "2_start" >}}): Run the PowerShell module to generate the continuous delivery environment.
- [Phase 3]({{< relref "3_deploy" >}}): Update the module (if needed) to suit the needs of your organization and deploy via continuous delivery.

{{< img name="alz-accelerator-overview" size="origin" lazy=true >}}
