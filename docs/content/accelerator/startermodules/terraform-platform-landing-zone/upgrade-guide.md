---
title: Upgrade Guidance
geekdocCollapseSection: true
weight: 5
---

## Staying up to date

Using the latest version of the ALZ Platform landing zone AVM pattern modules is the recommended approach for staying up to date with the latest architectural changes. From a governance perspective, this also ensures you have the latest recommended policies applied to your environment.

This upgrade guide covers the AVM pattern modules that are used to deploy the Platform landing zone. These are:

* [Management Groups Policy Library](#management-groups-and-policy-library)
* [Management Groups and Policy Module](#management-groups-and-policy-module)
* [Management Resources Module](#management-resources-module)
* [Connectivity with Hub and Spoke Virtual Network Module](#connectivity-with-hub-and-spoke-virtual-network-module)
* [Connectivity with Virtual WAN Module](#connectivity-with-virtual-wan-module)

With each release of the AVM pattern modules, it's possible that there will be changes that could impact your deployed resources. We do our best to ensure any changes are documented in the release notes. To avoid unexpected or unwanted changes we recommend that you configure your version constraints to pin to a specific module version.

Upgrade process consists of the following high level steps:

1. [Review the release notes](#1-review-the-release-notes)
2. [Update the module version](#2-update-the-module-version)
3. [Plan and apply with Terraform](#3-run-terraform-plan-and-apply)

## 1. Review the release notes

The release notes will provide you with information on what has changed in the module, including any breaking changes, new features, and bug fixes. This will help you understand what to expect when upgrading to the latest version.

## 2. Update the module version

To ensure you are using the latest version of the module, you will need to update the version constraint in your Terraform configuration file. This will allow you to pin to a specific version of the module, or allow for automatic upgrades to the latest patch release.

### Management Groups and Policy Library

The management group policy library module version declaration can be found in the [lib/alz_library_metadata.json](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/lib/alz_library_metadata.json)

The available versions of the policy library can be found in the repostory [releases](https://github.com/Azure/Azure-Landing-Zones-Library/releases). You'll need to find releases with the `platform/alz/*` prefix.

To update the version, you need to update the `ref` field in the `lib/alz_library_metadata.json` file.

To pin to a specific version of the module, you can use the following syntax:

```json
{
  ...
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "2025.02.0"
    }
  ]
}
```

To allow automatic upgrades to the latest patch release of a minor version, use the following version constraint syntax:

```json
{
  ...
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "~> 2025.02.0"
    }
  ]
}
```

### Management Groups and Policy Module

The management group module declaration can be found in the [modules/management_groups/main.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/modules/management_groups/main.tf) file.

The available versions of the module can be found in the [registry](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest).

To update the version, you need to update the `version` field in the `modules/management_groups/main.tf` file.

To pin to a specific version of the module, you can use the following syntax:

```terraform
module "management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.12.0"
  ...
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "~> 0.12.0"
  ...
}
```

### Management Resources Module

The management resources module declaration can be found in the [modules/management_resources/main.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/modules/management_resources/main.tf) file.

The available versions of the module can be found in the [registry](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest).

To update the version, you need to update the `version` field in the `modules/management_resources/main.tf` file.

To pin to a specific version of the module, you can use the following syntax:

```terraform
module "management_resources" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.6.0"
  ...
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "management_resources" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "~> 0.6.0"
  ...
}
```

### Connectivity with Hub and Spoke Virtual Network Module

The hub and spoke VNET module declaration can be found in the [main.connectivity.hub.and.spoke.virtual.network.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/main.connectivity.hub.and.spoke.virtual.network.tf) file.

The available versions of the module can be found in the [registry](https://registry.terraform.io/modules/Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm/latest).

To update the version, you need to update the `version` field in the `main.connectivity.hub.and.spoke.virtual.network.tf` file.

To pin to a specific version of the module, you can use the following syntax:

```terraform
module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "0.1.0"
  ...
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "~> 0.1.0"
  ...
}
```

### Connectivity with Virtual WAN Module

The virtual WAN module declaration can be found in the [main.connectivity.virtual.wan.tf](https://github.com/Azure/alz-terraform-accelerator/blob/main/templates/platform_landing_zone/main.connectivity.virtual.wan.tf) file.

The available versions of the module can be found in the [registry](https://registry.terraform.io/modules/Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm/latest).

To update the version, you need to update the `version` field in the `main.connectivity.virtual.wan.tf` file.

To pin to a specific version of the module, you can use the following syntax:

```terraform
module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "0.2.0"
  ...
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "~> 0.2.0"
  ...
}
```

## 3. Run Terraform Plan and Apply

### Local file system

Follow the steps below to deploy the landing zone locally. If you want to hook it up to your custom version control system, follow their documentation on how to do that.

The Terraform option outputs a `deploy-local.ps1` file that you can use to deploy the ALZ.
Follow the steps below to deploy the landing zone locally. If you want to hook it up to your custom version control system, follow their documentation on how to do that.

1. Navigate to the directory shown in the `module_output_directory_path` output from the bootstrap.
1. (Optional) Ensure you are still logged in to Azure using `az login --tenant 00000000-0000-0000-0000-000000000000`.
1. (Optional) Connect to your target subscription using `az account set --subscription 00000000-0000-0000-0000-000000000000`.
1. (Optional) Examine the `./scripts/deploy-local.ps1` to understand what it is doing.
1. Run `./scripts/deploy-local.ps1`.
1. A plan will run and then you'll be prompted to check it and run the deploy.
1. Type `yes` and hit enter to run the deploy.
1. The ALZ will now be deployed, this may take some time.

### Azure DevOps or GitHub

1. Clone your repository and create a new branch to test the upgrade.

    ```powershell
    git clone "https://<your-repo-url>"
    git checkout -b upgrade-module-versions
    ```

1. Open the repository in your IDE of choice (Visual Studion Code)
1. Find the files relevant to the modules you want to upgrade and make the changes as described in the [Update the module version](#2-update-the-module-version) section.
1. Commit and push your changes to the new branch.

    ```powershell
    git add .
    git commit -m "Upgrade module versions"

    # First commit only
    git push -u origin upgrade-module-versions

    # Subsequent commits
    git push
    ```

1. Raise a pull request from your branch to the `main` branch and allow the continuous integration pipeline / action to run.
1. Open the pipeline / action and examine the plan that was generated, being care to review any planned changes (create, update or destroy).
1. Repeat the previous steps until you are happy that the plpan is safe, then merge the pull request.
1. Trigger the continuous deleivery pipeline / action on the `main` branch. This will run a `plan`.
1. Review the `plan` again to ensure it is safe to apply, then approve the `plan` and run the `apply`.
1. Your resources and state will now be updated based on the specified version of the module(s).
