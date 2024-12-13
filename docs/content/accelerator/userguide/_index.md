---
title: User guide
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

Now follow the [introduction](#introduction) below.

## Advanced Users

For those users with very specific requirements we provide some advanced capabilities that allow you to override some of the defaults.

See our [FAQ]({{< relref "faq" >}}) and [Advanced Scenarios]({{< relref "advancedscenarios" >}}) for more info.

## Introduction

This guide takes you through the steps to prepare your pre-requisites and then run the PowerShell module.

The accelerator bootstraps a continuous delivery environment for you. It supports both the Azure DevOps and GitHub version control system (VCS). It uses the [ALZ PowerShell module](https://www.powershellgallery.com/packages/ALZ) to gather required user input and apply a Terraform module to configure the bootstrap environment.

The accelerator follows a 3 phase approach:

- [Phase 1]({{< relref "1_prerequisites" >}}): Instructions to configure credentials and subscriptions.
- [Phase 2]({{< relref "2_start" >}}): Run the PowerShell module to generate the continuous delivery environment.
- [Phase 3]({{< relref "3_deploy" >}}): Update the module (if needed) to suit the needs of your organization and deploy via continuous delivery.

{{< img name="alz-accelerator-overview" size="origin" lazy=true >}}
