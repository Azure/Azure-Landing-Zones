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

Not currently. The Platform landing zone requires **AzureRM provider v4**, as we are planning to move to the AzAPI provider. Keep the AzureRM constraint in your root module set to `~> 4.0`.

See [Terraform and provider versions]({{< relref "../starter-terraform/module-index#terraform-and-provider-versions" >}}), or [Troubleshooting]({{< relref "../troubleshooting#no-available-releases-match-the-given-constraints-for-hashicorpazurerm" >}}) if `terraform init` is failing.
