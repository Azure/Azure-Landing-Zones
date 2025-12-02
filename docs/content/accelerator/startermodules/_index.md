---
title: Starter Modules
weight: 10
geekdocCollapseSection: true
---

The Azure landing zones accelerator includes a number of starter modules that provide opinionated implementations of the Bicep or Terraform Azure landing zones modules.

These are called starter modules because the expectation is you'll update these modules as the needs of your organization evolves and you want to add or remove features to your landing zone.

Each starter module expects different inputs and the following pages detail those inputs. You'll be prompted for these inputs when you run the Accelerator PowerShell module.

## Bicep Starter Modules

- **[Bicep AVM - Platform Landing Zone]({{< relref "bicep-platform-landing-zone" >}})**: New framework using Azure Verified Modules (iac_type: `bicep`)
- **[Bicep Classic - Complete]({{< relref "bicep-classic-complete" >}})**: Traditional framework (iac_type: `bicep-classic`)

## Terraform Starter Modules

- **[Terraform Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "terraform-platform-landing-zone" >}})**: Management groups, policies, hub networking with fully custom configuration.
