---
title: Phase 2 - Run PowerShell
---

Phase 2 of the accelerator is to run the bootstrap. Follow the steps below to do that.

## 2.1 Install the ALZ PowerShell module

The ALZ PowerShell module is used to run the bootstrap phase. It is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/ALZ/). You can install it using the following steps:

1. Open a PowerShell Core (pwsh) terminal.
2. Check if you already have the ALZ module installed  by running `Get-InstalledModule -Name ALZ`. You'll see something like this if it is already installed:

```powershell
Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.0.0      ALZ                                 PSGallery            Azure Landing Zones Powershell Module
```

3. If the module is already installed, run `Update-Module -Name ALZ` to ensure you have the latest version.
4. If the module is not installed, run `Install-Module -Name ALZ`.

## 2.2 Run the Bootstrap

You are now ready to run the bootstrap and setup your environment. If you want to use custom names for your resources or automate the bootstrap, please refer to our [FAQs](https://github.com/Azure/alz-terraform-accelerator/wiki/Frequently-Asked-Questions) section.

The inputs differ depending on the version control system and infrastructure as code tooling you have chosen. Click through to the relevant page for detailed instructions:

- [Azure DevOps]({{< relref "2b_azuredevops" >}})
- [GitHub]({{< relref "2a_github" >}})
- [Local file system]({{< relref "2c_local" >}})

## Next Steps

Once the steps in the VCS specific section are completed, head to [Phase 3]({{< relref "3_deploy" >}}).
