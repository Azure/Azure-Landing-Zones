---
title: Phase 0 - Planning
geekdocCollapseSection: true
weight: 1
---

Phase 0 of the accelerator is to plan your deployment. Follow the steps below to do that.

{{< hint type=note >}}
This phase is optional. You can skip it and go straight to [Phase 1]({{< relref "1_prerequisites" >}}) if you already know what you want to deploy.
{{< /hint >}}

## 1 - Learn

Learn about the Azure landing zones architecture and the accelerator.

### Glossary

You should understand these terms before you start:

* Infrastructure as Code (IaC): Infrastructure as Code (IaC) is the process of managing and provisioning computing infrastructure through machine-readable definition files, rather than through physical hardware configuration or interactive configuration tools. This is a key component of the accelerator.
* Platform Landing Zone: Understand the scope of the Platform Landing Zone [here](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/).
* Bootstrap or Bootstrap Module: The IaC module that sets up the version control system, continuous delivery pipeline, required Azure resources, etc. The bootstrap happens before the Platform Landing Zone is deployed.
* Starter or Starter Module: This is a pre-configured IaC module that can be used to deploy a specific platform landing zone configuration.
* Accelerator PowerShell Module: The PowerShell module that is used to deploy the bootstrap. Find it here: [https://www.powershellgallery.com/packages/ALZ](https://www.powershellgallery.com/packages/ALZ).

### Technical Knowledge

You should have a good understanding of the following technologies and concepts:

* Terraform Workflow: Understand the standard write, init, plan and apply workflow. [Learning path](https://aka.ms/tf/fundamentals)
* Terraform HCL (HashiCorp Configuration Language): Understand the basics of HCL. [Learning path](https://aka.ms/tf/labs)
* DevOps: Understand the fundamentals of DevOps. [Learning path](https://learn.microsoft.com/training/modules/introduction-to-devops/)
* Continuous Integration and Delivery: Understand the basics of CI/CD. [Learning path](https://learn.microsoft.com/training/modules/explain-devops-continous-delivery-quality/)
* git version control: Understand the fundamentals of git. [Learning path](https://learn.microsoft.com/training/modules/intro-to-git/)

## 2 - Download the checklist

We provide a spreadsheet that you can use to help gather the required information to make choices and fill out configuration files. You can download it {{< a-download href="examples/tf/accelerator/config/checklist.xlsx" download="checklist.xlsx" >}}HERE{{< /a-download >}}.

This file has several tabs, described here:

* Accelerator - Bootstrap: This tab details the settings required for the bootstrap configuration
* Accelerator - Bicep: This tab details the settings required for the Bicep configuration
* Accelerator - Terraform - ALZ: This tab details the settings required for the Azure Verified Modules for Platform Landing Zone (ALZ) configuration
* Accelerator - Terraform - SLZ: This tab details the settings required for the Sovereign Landing Zone configuration

{{< hint type=tip >}}
As an advanced user, you can go right ahead and fill in the configuration file directly, you don't have to use the spreadsheet.
{{< /hint >}}

After following this set of decisions, you will have a completed `checklist.xlsx` file that you can use in phases 1 and 2.

There are two sets of decisions to make, one for the bootstrap and one for the platform landing zone.

* [Bootstrap Decisions](#3---bootstrap-decisions)
* [Platform Landing Zone (Starter) Decisions](#4---platform-landing-zone-starter-decisions)

## 3 - Bootstrap Decisions

The following decisions need to be made before you start the bootstrap process.

Fill out the `Accelerator - Bootstrap` tab of the `checklist.xlsx` file with the relevant settings for the bootstrap configuration by following these steps below:

{{< hint type=tip >}}
Each decision number maps to a decision number in the `checklist.xlsx` file.
{{< /hint >}}

### Decision 1 - Choose Infrastructure as Code (IaC) tooling

The accelerator supports both Bicep and Terraform. You need to choose one of these to use for the bootstrap process.

Fill out the `Infrastructure as Code` value with either `bicep` or `terraform`.

### Decision 2 - Choose a version control system

We currently support bootstrapping of Azure DevOps or GitHub.

Hopefully you've already chosen one of these for your organization, but if not you can go off and do some research now before continuing.

If you are using another version control system, then we also offer an option to output to the local file system. You can run directly from there, or take those files and implement your own CI/CD pipeline.

Choose either:

* Azure DevOps: Choose this option if you are using Azure DevOps.
* GitHub: Choose this option if you are using GitHub.
* Local: Choose this option if you are using another version control system, such as GitLab or Bitbucket.

Fill out the `Version control system` value with either `alz_azuredevops`, `alz_github`, or `alz_local`.

### Decision 3 - Choose a starter module

Below is a table describing the available starter modules, along with guidance on their use:

| Starter Module | Setting | Description | Recommendation |
|--|--|----|---|
| [Bicep - Complete]({{< relref "../startermodules/bicepcomplete">}}) | `complete` | Multi-region implementation using Azure Verified Modules for networking that accepts a configuration file to customize. | Use this for Bicep |
| [Terraform - Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "../startermodules/terraform-platform-landing-zone">}}) | `platform_landing_zone` | Multi-region implementation using Azure Verified Modules for networking that accepts a configuration file to customize. | Use this for any customer that does not want SLZ or FSI |
| [Terraform - Sovereign Landing Zone]({{< relref "../startermodules/terraformsovereign" >}}) | `sovereign_landing_zone` | Compliance-focused implementation for regulated industries demanding high data sovereignty. | Select for government and regulated industry environments. |
| [Terraform - Financial Services Industry Landing Zone]({{< relref "../startermodules/terraformfsi" >}}) | `financial_services_landing_zone` | Compliance-focused implementation for the financial services industry. | Select for financial service industry environments. |

Fill out the `Starter module` value with either `complete`, `platform_landing_zone`, `sovereign_landing_zone`, or `financial_services_landing_zone`.

### Decision 4 - Choose a region for the bootstrap resources

The bootstrap resources are deployed to a single region. Choose the Azure region where you would like to deploy them.

The bootstrap resources include:

* Resource groups
* Storage account for state (Terraform only)
* User assigned managed identities
* Role definitions and assignments (non-regional)

Fill out the `Bootstrap region` value with the Azure region you have chosen.

### Decision 5 - Choose region(s) for the platform landing zone resources

The platform landing zone resources are deployed to one or more regions. Choose the Azure region(s) where you would like the deploy them.

Hopefully you have already chosen your initial regions by now and this may be guided by your data sovereignty or latency requirements.

Fill out the `Platform landing zone region(s)` value with the Azure region(s) you have chosen.

### Decision 6 - Choose a parent management group

The parent management group is the management group that will contain the management groups created by the bootstrap. The parent management group must exist before the bootstrap is run.

We recommend using `Tenant Root Group`, the platform landing zone management group hierarchy will be build underneath the chosen parent management group. The only changes to the parent management group will be permissions, no policies are applied at that level.

{{< hint type=warning >}}
If a parent management group other than Tenant Root Group is chosen, then move the 3 platform subscriptions into the management group before proceeding.
{{< /hint >}}

Fill out the `Parent management group id` value with the management group you have chosen.

### Decision 7 - Choose the platform subscriptions

We strongly encourage and only support using 4 platform subscription with separate Management, Connectivity, Identity, and Security platform subscriptions.

{{< hint type=note >}}
A single subscription model is technically possible, but only recommended for sandbox testing purposes.
{{< /hint >}}

You may wish to follow the steps in the [phase 1 prerequisites]({{< relref "1_prerequisites/platform-subscriptions">}}) to create the 4 platform subscriptions and add the subscription IDs to the checklist now.

Fill out the `Management subscription id`, `Connectivity subscription id`, `Identity subscription id`, and `Security subscription id` values with the subscription IDs you have chosen.

### Decision 8 - Choose the bootstrap subscription

The customer can choose to use a 4 or 5 subscription model. The 5 subscription model is where the bootstrap resources are deployed to a 5th subscription. Should they wish to do that, you can follow the advice found [HERE]({{< relref "advancedscenarios">}}).

In either case, you should make a choice of where to place the bootstrap resources. We recommend using the Management platform subscription if you don't need the 5 subscription model.

The customer can target this subscription explicitly by setting the `bootstrap_subscription_id` variable in the bootstrap configuration file or ensure you are connected to it via az cli.

Fill out the `Bootstrap subscription id` value with the subscription ID you have chosen.

### Decision 9 - Choose the bootstrap resource naming

Choose a `service name` and `environment name` that will be used to derive the bootstrap resource names.

{{< hint type=tip >}}
If you must use an alternative naming convention, they can be overridden by follow the instructions found [HERE]({{< relref "../faq">}})
{{< /hint >}}

Fill out the `Service name` and `Environment name` values with the names you have chosen.

### Decision 10 - Choose the bootstrap networking

We offer 3 agent / runner and networking options for the bootstrap. The options and related settings are listed here:

* Private networking with self-hosted agents / runners
  * Azure DevOps:
    * `use_private_networking` = `true`
    * `use_self_hosted_agents` = `true`
  * GitHub:
    * `use_private_networking` = `true`
    * `use_self_hosted_runners` = `true`
* Public networking with self-hosted agents / runners
  * Azure DevOps:
    * `use_private_networking` = `false`
    * `use_self_hosted_agents` = `true`
  * GitHub:
    * `use_private_networking` = `false`
    * `use_self_hosted_runners` = `true`
* Public networking with Microsoft-hosted agents / runners
  * Azure DevOps:
    * `use_private_networking` = `false`
    * `use_self_hosted_agents` = `false`
  * GitHub:
    * `use_private_networking` = `false`
    * `use_self_hosted_runners` = `false`

{{< hint type=note >}}
Self-hosted agents / runners are required for private networking, so that setting will be ignored if private networking is selected.
{{< /hint >}}

Fill out the `Use private networking`, `Use self-hosted agents`, and / or `Use self-hosted runners` values with the settings you have chosen.

### Decision 11 - Choose / validate your version control system specific settings

Review the remaining settings in the `Accelerator - Bootstrap` tab of the `checklist.xlsx` file and fill out any remaining settings relevant to the chosen version control system.

You may wish to follow the steps for [phase 1 pre-requisites Azure DevOps]({{< relref "1_prerequisites/azuredevops">}}) or [phase 1 pre-requisites GitHub]({{< relref "1_prerequisites/github">}}) to create the personal access tokens (PAT) and add the PAT to the checklist.

## 4 - Platform Landing Zone (Starter) Decisions

{{< hint type=note >}}
This section applies only to the Terraform Azure Verified Modules for Platform Landing Zone (ALZ) starter module at this time. For all others, continue on to [Phase 1]({{< relref "1_prerequisites">}}).
{{< /hint >}}

The following decisions need to be made before you start the starter module process.

Fill out the `Accelerator - Terraform - ALZ` tab of the `checklist.xlsx` file with the relevant setting decisions by following these steps below:

### Decision 1 - Choose a scenario

The Azure Verified Modules for Platform Landing Zone (ALZ) starter module supports a number of scenarios as a starting point.

The scenarios can be found in the [SCENARIOS]({{< relref "../startermodules/terraform-platform-landing-zone/scenarios" >}}) section.

Choose a scenario that best fits your requirements.

Fill out the `Scenario` section with the scenario you have chosen.

### Decision 2 - Choose options

The Azure Verified Modules for Platform Landing Zone (ALZ) starter module supports a number of options that can be applied to a scenario.

The options can be found in the [OPTIONS]({{< relref "../startermodules/terraform-platform-landing-zone/options" >}}) section.

Choose the options that best fit your requirements.

Fill out the `Options` section with the options you have chosen.

## Next Steps

Now head to [Phase 1]({{< relref "1_prerequisites" >}}).
