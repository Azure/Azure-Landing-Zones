---
title: Starter modules
---

The Azure landing zones accelerator includes a number of starter modules that provide opinionated implementations of the Bicep or Terraform Azure landing zones modules.

These are called starter modules because the expectation is you'll update these modules as the needs of your organization evolves and you want to add or remove features to your landing zone.

Each starter module expects different inputs and the following pages detail those inputs. You'll be prompted for these inputs when you run the Accelerator PowerShell module.

- [Bicep Complete Starter Module]({{< relref "bicepcomplete" >}}): Management groups, policies and hub networking.
- [Terraform Basic Starter Module]({{< relref "terraformbasic" >}}): Management groups and policies.
- [Terraform Hub Networking Starter Module]({{< relref "terraformhubnetworking" >}}): Management groups, policies and hub networking.
- [Terraform Complete Starter Module]({{< relref "terraformcomplete" >}}): Management groups, policies, hub networking with fully custom configuration.
- [Terraform FSI Starter Module]({{< relref "terraformfsi" >}}): Management groups, policies, hub networking and financial services industry (FSI) specific configurations.
- [Terraform Sovereign Starter Module]({{< relref "terraformsovereign" >}}): Management groups, policies, hub networking and sovereign cloud specific configurations.
