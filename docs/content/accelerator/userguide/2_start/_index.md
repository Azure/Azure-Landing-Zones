---
title: Phase 2 - Bootstrap
geekdocCollapseSection: true
weight: 5
---

Phase 2 of the accelerator is to run the bootstrap. Follow the steps below to do that.

## 2.1 Install the ALZ PowerShell module

The ALZ PowerShell module is used to run the bootstrap phase. It is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/ALZ/). You can install it using the following steps:

1. Open a PowerShell Core (pwsh) terminal.

    {{< hint type=warning >}}
Double check you are running in a PowerShell Core terminal. Run `$psversiontable` to check.
    {{< /hint >}}

2. Check if you already have the ALZ module installed  by running `Get-InstalledModule -Name ALZ`. You'll see something like this if it is already installed:

```powershell
Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.0.0      ALZ                                 PSGallery            Azure Landing Zones Powershell Module
```

3. If the module is already installed, run `Update-Module -Name ALZ` to ensure you have the latest version.
4. If the module is not installed, run `Install-Module -Name ALZ`.

## 2.2 Run the Bootstrap

You are now ready to run the bootstrap and setup your environment. If you want to use custom names for your resources or automate the bootstrap, please refer to our [FAQs]({{< relref "../../faq" >}}) section.

The inputs differ depending on the version control system and infrastructure as code tooling you have chosen.

### 2.2.1 Bicep

Click through to the relevant page for detailed instructions:

* [Azure DevOps with Bicep]({{< relref "bicep-azuredevops" >}})
* [GitHub with Bicep]({{< relref "bicep-github" >}})
* [Local File System]({{< relref "bicep-local" >}})

### 2.2.2 Terraform

Click through to the relevant page for detailed instructions:

* [Azure DevOps with Terraform]({{< relref "terraform-azuredevops" >}})
* [GitHub with Terraform]({{< relref "terraform-github" >}})
* [Local File System with Terraform]({{< relref "terraform-local" >}})

## Next Steps

Once the steps in the VCS specific section are completed, head to [Phase 3]({{< relref "3_deploy" >}}).
