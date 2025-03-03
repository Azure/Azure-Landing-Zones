---
title: FAQ
weight: 15
---

This article answers frequently asked questions relating to the Azure landing zones Terraform accelerator.

{{< hint type=note >}}
If you have a question not listed here, please raise an [Issue](https://github.com/Azure/ALZ-PowerShell-Module/issues) and we'll do our best to help.
{{< /hint >}}

## Questions about customization

### How do I use my own naming convention for the resources that are deployed?

You can add any hidden variables to your inputs file, including the `resource_names` map. This map is used to set the names of the resources that are deployed. You can find the default values in the `variables.hidden.tf` file in the bootstrap module:

* Azure DevOps: [variables.hidden.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/2b3aa805fd03fa5afa4de970ca11899a9a66d2a6/alz/azuredevops/variables.hidden.tf#L79)
* GitHub: [variables.hidden.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/2b3aa805fd03fa5afa4de970ca11899a9a66d2a6/alz/github/variables.hidden.tf#L13)
* Local: [variables.hidden.tf](https://github.com/Azure/accelerator-bootstrap-modules/blob/2b3aa805fd03fa5afa4de970ca11899a9a66d2a6/alz/local/variables.hidden.tf#L25)

For example adding this to the end of your bootstrap config file and updating to your naming standard:

```yaml
# Extra Inputs
resource_names:
  resource_group_state: "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}-test"
  resource_group_identity: "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
  resource_group_agents: "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
  resource_group_network: "rg-{{service_name}}-{{environment_name}}-network-{{azure_location}}-{{postfix_number}}"
  user_assigned_managed_identity_plan: "id-{{service_name}}-{{environment_name}}-{{azure_location}}-plan-{{postfix_number}}"
  user_assigned_managed_identity_apply: "id-{{service_name}}-{{environment_name}}-{{azure_location}}-apply-{{postfix_number}}"
  user_assigned_managed_identity_federated_credentials_plan: "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-plan"
  user_assigned_managed_identity_federated_credentials_apply: "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-apply"
  storage_account: "sto{{service_name_short}}{{environment_name_short}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
  storage_container: "{{environment_name}}-tfstate"
  container_instance_01: "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  container_instance_02: "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_1}}"
  container_instance_managed_identity: "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-aci"
  agent_01: "agent-{{service_name}}-{{environment_name}}-{{postfix_number}}"
  agent_02: "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_1}}"
  version_control_system_repository: "{{service_name}}-{{environment_name}}"
  version_control_system_repository_templates: "{{service_name}}-{{environment_name}}-templates"
  version_control_system_service_connection_plan: "sc-{{service_name}}-{{environment_name}}-plan"
  version_control_system_service_connection_apply: "sc-{{service_name}}-{{environment_name}}-apply"
  version_control_system_environment_plan: "{{service_name}}-{{environment_name}}-plan"
  version_control_system_environment_apply: "{{service_name}}-{{environment_name}}-apply"
  version_control_system_variable_group: "{{service_name}}-{{environment_name}}"
  version_control_system_agent_pool: "{{service_name}}-{{environment_name}}"
  version_control_system_group: "{{service_name}}-{{environment_name}}-approvers"
  version_control_system_pipeline_name_ci: "01 Azure Landing Zones Continuous Integration"
  version_control_system_pipeline_name_cd: "02 Azure Landing Zones Continuous Delivery"
  virtual_network: "vnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  public_ip: "pip-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  nat_gateway: "nat-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  subnet_container_instances: "subnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-aci"
  subnet_private_endpoints: "subnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-pe"
  storage_account_private_endpoint: "pe-{{service_name}}-{{environment_name}}-{{azure_location}}-sto-{{postfix_number}}"
  container_registry: "acr{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
  container_registry_private_endpoint: "pe-{{service_name}}-{{environment_name}}-{{azure_location}}-acr-{{postfix_number}}"
  container_image_name: "azure-devops-agent"
```

## Questions about bootstrap clean up

### I was just testing or I made a mistake, how do I remove the bootstrap environment and start again?

After the Terraform apply has been completed there is an opportunity to remove the environment it just created. Follow these steps to run a `terraform destroy`.

1. If you already ran the CD pipeline / action in phase 3 to deploy the ALZ, then you will need to run the pipeline / action again, but this time select the `destroy` option. This will delete the landing zone resources. If you don't do this, those resource will be left orphaned and you will have to clean them up manually.
1. Wait for the destroy run to complete before moving to the next step, you will need to approve it if you configured approvals.
1. Now run `Deploy-Accelerator` with the `-destroy` flag, for example:

    {{< tabs "1" >}}
    {{< tab "Windows" >}}
```pwsh
Deploy-Accelerator `
  -inputs "c:\accelerator\config\inputs.yaml", "c:\accelerator\config\platform-landing-zone.tfvars" `
  -output "c:\accelerator\output" `
  -destroy
```
    {{< /tab >}}
    {{< tab "Linux / macOS" >}}
```pwsh
Deploy-Accelerator `
  -inputs "/accelerator/config/inputs.yaml", "/accelerator/config/platform-landing-zone.tfvars" `
  -output "/accelerator/output" `
  -destroy
```
    {{< /tab >}}
    {{< /tabs >}}

1. You can confirm the destroy by hitting enter when prompted.
1. To fully clean up, you should now delete the folder that was created for the accelerator.
1. You'll now be able to run the `Deploy-Accelerator` command again to start fresh.

## Questions about changing variables

### I made a mistake in the variables I entered, do I need to re-enter them all?

When you run the PowerShell module, it caches the responses you supply. If you make a mistake, you can re-run the `Deploy-Accelerator` command and it will ask you if you want to use the cached variables. If you hit enter here, then you will be able to skip through each variable in turn, check the set value and alter it if desired.

### I want to update a variable after the bootstrap has been completed, how do I do that?

When you run the PowerShell module, it caches the responses you supply. If you want to update a variable, you can re-run the `Deploy-Accelerator` command and it will ask you if you want to use the cached variables. If you hit enter here, then you will be able to skip through each variable in turn, check the set value and alter it if desired.

> NOTE: In some cases changing a variable may result in a change to a starter module or CI / CD file. In this scenario you may see an error on Terraform Apply due to branch protection. You can disable branch protection and re-run the `Deploy-Accelerator` command to resolve this.

## Questions about Upgrading to a newer version of the accelerator

### How do I upgrade to a newer version of the accelerator?

Follow the steps in the [Upgrade Guide]({{< relref "upgradeguide" >}}) to upgrade to a newer version of the accelerator.

## Questions about Multiple landing zone deployments

### I want to deploy multiple landing zones, but the PowerShell command keeps trying to overwrite my existing environment

After bootstrapping, the PowerShell leaves the folder structure intact, including the Terraform state file. This is by design, so you have an opportunity to amend or destroy the environment.

If you want to deploy to a separate environment, the simplest approach is to specify a separate folder for each deployment using the `-output` parameter. For example:

* Deployment 1: `Deploy-Accelerator -inputs "~/config/inputs1.json" -output "./deployment1"`
* Deployment 2: `Deploy-Accelerator -inputs "~/config/inputs2.json" -output "./deployment2"`

You can then deploy as many times as you like without interferring with a previous deployment.

## Questions about Automating the PowerShell Module

### I get prompted to approve the Terraform plan, can I skip that?

Yes, you can skip the approval of the Terraform plan by using the `-autoApprove` parameter.

For example:

```powershell
Deploy-Accelerator -inputs "~/config/inputs.json" -output "./deployment1" -autoApprove
```

## Questions about adding more subscriptions post initial deployment

### I used a single subscription for the initial deployment, how do I split my landing zone to the recommended 3 subscriptions?

There are some steps you need to take:

1. Create a new subscription and take a note of the subscriptions ID.
1. Find the names of the user assigned managed identities that were created in the initial boostrap. There should be one for `plan` and one for `apply`.
1. Go to the `Access control (IAM)` section pf the subscription. Add the following permissions for each user assigned managed identity:
    1. `Reader` to the `plan` identity
    1. `Owner` to the `apply` identity
1. Go to your Terraform code in source control and update the `terraform.tfvars` file, specifying the new subscription id in the relevant variable. You will need to create a branch and raise a PR to do this.
1. You can now plan and apply from pipelines to update the subscriptions.

## Questions about using custom starter modules

### I want to use my own custom bootstrap module(s), how do I do that?

Follow the structure and json schema in the [Azure/accelerator-bootstrap-modules](https://github.com/Azure/accelerator-bootstrap-modules) repository. You can then target your custom bootstrap module by using the `bootstrapModuleUrl` or `bootstrapModuleOverrideFolderPath` parameters in the PowerShell module. For example:

```powershell
Deploy-Accelerator -inputs "~/config/inputs.json" -bootstrapModuleUrl "https://github.com/my-org/my-boostrap-modules"
```

```powershell
Deploy-Accelerator -inputs "~/config/inputs.json" -bootstrapModuleOverrideFolderPath "./my-bootstrap-modules"
```

### I want to use my own custom starter modules, how do I do that?

Follow the folder structure in the [Azure/alz-terraform-accelerator](https://github.com/Azure/accelerator-terraform-accelerator) repository and create your own custom starter module(s). You can then target your custom starter module by using the `starterModuleOverrideFolderPath` parameters in the PowerShell module. For example:

```powershell
Deploy-Accelerator -inputs "~/config/inputs.json" -starterModuleOverrideFolderPath "~/my-custom-starter-modules"
```

Alternatively, if you are also supplying a custom bootstrap module, you can specify the starter module repo url in the `json` config file in the bootstrap module.
