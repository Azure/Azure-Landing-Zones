---
title: Accelerator Upgrade FAQ
weight: 30
---

## Is it possible to upgrade to a newer version of the bootstrap?

Not currently. The bootstrap is a one-time operation. We plan to support upgrades in the future.

## How do I upgrade to a newer version of the Platform landing zone?

Follow the steps in the relevant for your chosen Infrastructure as Code (IaC) tool.

* [Terraform Upgrade Guide]({{< relref "../starter-terraform/upgrade-guide" >}})
* Bicep coming soon.

## Does the Terraform Platform landing zone support AzureRM provider v5?

No. Continue to use AzureRM provider v4 and keep the root provider constraint set to `~> 4.0`.

We are migrating the remaining AzureRM-based components to AzAPI. We do not plan to add support for AzureRM provider v5.
