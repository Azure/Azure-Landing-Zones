## Staying up to date

Using the latest version of the ALZ Platform landing zone pattern modules is the recommended approach for staying up to date with the latest architectural changes. From a governance perspective, this also ensures you have the latest recommended policies applied to your environment.

This upgrade guide covers four AVM pattern modules that are used to deploy the Platform landing zone. The modules are:
- [Management Groups and Policy](management_groups)
- [Management Resources](management_resources)
- [Connectivity with Hub and Spoke Virtual Network](hub_and_spoke_vnet)
- [Connectivity with Virtual WAN](virtual_wan)


With each release of the AVM pattern modules, it's possible that there will be changes that could impact your deployed resources. We do our best to ensure any changes are documented in the release notes. To avoid unexpected or unwanted changes we recommend that you configure your version constraints to pin to a specific module version.

Upgrade process consists of the following steps:
1. [Review the release notes](#review-the-release-notes)
2. [Update the module version](#2-update-the-module-version)
3. [Run terraform plan to see what changes will be made to your environment](#3-run-terraform-plan)


## 1. Review the release notes

The release notes will provide you with information on what has changed in the module, including any breaking changes, new features, and bug fixes. This will help you understand what to expect when upgrading to the latest version.

## 2. Update the module version
To ensure you are using the latest version of the module, you will need to update the version constraint in your Terraform configuration file. This will allow you to pin to a specific version of the module, or allow for automatic upgrades to the latest patch release.


### hub_and_spoke_vnet Module
To pin to a specific version of the module, you can use the following syntax:

```terraform
module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "<version>" 
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "hub_and_spoke_vnet" {
  source  = "Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet/azurerm"
  version = "~> 0.1.2"
}
```


### Virtual_Wan Module
To pin to a specific version of the module, you can use the following syntax:


```terraform
module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "<version>" 
}
```

To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "virtual_wan" {
  source  = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version = "~> 0.1.2"
}
```

###  Management Group Module
    
```terraform
module "management_groups" {
    source     = "Azure/avm-ptn-alz/azurerm"
    version = "<version>"
}
```
To allow automatic upgrades to the latest patch release, use the following version constraint syntax:

```terraform
module "management_groups" {
 source     = "Azure/avm-ptn-alz/azurerm"
 version     = "~> 0.16.0"
}
 ```

## 3.Run Terraform Plan and Apply

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

### Azure DevOps
1. In your Azure DevOps repository, create a new branch to test the upgrade. This ensures your changes are isolated and can be tested without affecting the main branch.

2. Modify the `version` field in Terraform module configuration to the desired version. Use version constraints to pin to a specific version or allow automatic upgrades to the latest patch release.

3. Commit your changes to the new branch and update the pipeline to use the new branch.
4. Run the pipeline to deploy the changes. The pipeline will automatically run `terraform plan` and `terraform apply` with the approval to deploy the changes to your environment.

5. Review the changes in feature branch and ensure everything is working as expected. then merge the changes into the main branch.
6. Run the pipeline again to see the plan and deploy the changes to the Azure environment.

### Github
1. In your Github repository, create a new branch to test the upgrade. This ensures your changes are isolated and can be tested without affecting the main branch.

2. Modify the `version` field in Terraform module configuration to the desired version. Use version constraints to pin to a specific version or allow automatic upgrades to the latest patch release.

3. Commit and Sync your changes to the new branch.
4. Run the pipeline to deploy the changes. The pipeline will automatically run `terraform plan` and `terraform apply` with the approval to deploy the changes to your environment.
5. Review the changes in feature branch and ensure everything is working as expected. then merge the changes into the main branch.
6. Run the pipeline again to see the plan and deploy the changes to the Azure environment.

