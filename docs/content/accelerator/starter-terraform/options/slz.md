---
title: 15 - Implement Sovereign Landing Zone (SLZ) controls
geekdocCollapseSection: true
weight: 15
---

The Sovereign Landing Zone (SLZ) is a compliance-focused implementation designed for regulated industries that demand high data sovereignty. It incorporates specific controls and configurations to meet stringent regulatory requirements. The SLZ policies can be reviewd here:

- [Sovereignty Baseline - Global Policies](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/c1cbff38-87c0-4b9f-9f70-035c7a3b5523.html)
  - Applied at the root management group level
- [Sovereignty Baseline - Confidential Policies](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/03de05a4-c324-4ccd-882f-a814ea8ab9ea.html)
  - Applied at the Confidential Corp and Confidential Online management group levels

The steps to follow are:

1. Copy the SLZ `lib` files over the top of your existing `lib` folder. This will add the necessary configuration files to enable the SLZ management groups and policies.

    ```pwsh
    $tempFolderName = "~/accelerator/temp"
    New-Item -ItemType "directory" $tempFolderName
    $tempFolder = Resolve-Path -Path $tempFolderName
    git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-terraform-accelerator" "$tempFolder"
    cd $tempFolder

    $libFolderPath = "templates/platform_landing_zone/examples/slz/lib"
    git sparse-checkout set --no-cone $libFolderPath
    git checkout

    cd ~
    Copy-Item -Path "$tempFolder/$libFolderPath" -Destination "~/accelerator/config" -Recurse -Force
    Remove-Item -Path $tempFolder -Recurse -Force

    ```

1. Open your `platform-landing-zone.tfvars` file in Visual Studio Code (or your preferred editor) and update the following inputs:

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | block | `management_group_settings` > `policy_default_values` | `allowed_locations` | Uncomment the block and add any extra locations you want to allow into the array | 1 | |
