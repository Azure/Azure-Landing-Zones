---
title: Quickstart
resources:
  - name: alz-accelerator-overview
    src: img/alz-terraform-accelerator.png
    alt: A process flow showing the areas covered by the Azure landing zones Terraform accelerator.
    title: ALZ Accelerator Overview
---

## Introduction

The quick start guide takes you through the steps to prepare your pre-requisites and then run the PowerShell module.

The accelerator bootstraps a continuous delivery environment for you. It supports both the Azure DevOps and GitHub version control system (VCS). It uses the [ALZ PowerShell module](https://www.powershellgallery.com/packages/ALZ) to gather required user input and apply a Terraform module to configure the bootstrap environment.

The accelerator follows a 3 phase approach:

- [Quick Start Phase 1]({{< relref "1_prerequisites" >}}): Instructions to configure credentials and subscriptions.
- [Quick Start Phase 2]({{< relref "2_start" >}}): Run the PowerShell script to generate the continuous delivery environment.
- [Quick Start Phase 3]({{< relref "3_deploy" >}}): Update the module (if needed) to suit the needs of your organisation and deploy via continuous delivery.

{{< img name="alz-accelerator-overview" size="origin" lazy=true >}}
