---
title: GitHub with Terraform
---

Follow these instructions to bootstrap GitHub ready to deploy your platform landing zone with Terraform.

1. Create a new folder on you local drive called `accelerator`.
1. Inside the accelerator create two folders called `config` and `output`. You'll store you input file inside config and the output folder will be the place that the accelerator stores files while it works.
1. Inside the `config` folder create a new files called `inputs.yaml` and `platform-landing-zone.tfvars`.

    {{< hint type=note >}}
If you are using the FSI or SLZ starter modules, you do not currently require the `tfvars` file, so you can exclude it.
    {{< /hint >}}

    {{< tabs "1" >}}
    {{< tab "Windows" >}}

```pwsh
New-Item -ItemType "file" c:\accelerator\config\inputs.yaml -Force
New-Item -ItemType "file" c:\accelerator\config\platform-landing-zone.tfvars -Force  # Exclude this line if using FSI or SLZ starter modules
New-Item -ItemType "directory" c:\accelerator\output
```

    {{< /tab >}}
    {{< tab "Linux / macOS" >}}

```pwsh
Set-Location "$HOME"
New-Item -ItemType "file" ./accelerator/config/inputs.yaml -Force
New-Item -ItemType "file" ./accelerator/config/platform-landing-zone.tfvars -Force  # Exclude this line if using FSI or SLZ starter modules
New-Item -ItemType "directory" ./accelerator/output
```

    {{< /tab >}}
    {{< /tabs >}}

    ```plaintext
    📂accelerator
    ┣ 📂config
    ┃ ┃ 📜inputs.yaml
    ┃ ┗ 📜platform-landing-zone.tfvars
    ┗ 📂output
    ```

1. Open your `inputs.yaml` file in Visual Studio Code (or your preferred editor) and copy the content from the relevant input file for your chosen starter module:
    1. Azure Verified Modules for Platform Landing Zone (ALZ) - [inputs-github.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/platform_landing_zone/examples/bootstrap/inputs-github.yaml)
    1. Financial Services Industry Landing Zone - [inputs-github.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/microsoft_cloud_for_industry/financial_services_landing_zone/examples/bootstrap/inputs-github.yaml)
    1. Sovereign Landing Zone - [inputs-github.yaml](https://raw.githubusercontent.com/Azure/alz-terraform-accelerator/refs/heads/main/templates/microsoft_cloud_for_industry/sovereign_landing_zone/examples/bootstrap/inputs-github.yaml)

1. Check through the file and update each input as required. It is mandatory to update items with placeholders surrounded by angle brackets `<>`:

    {{< hint type=tip >}}
The following inputs can also be supplied via environment variables. This may be useful for sensitive values you don't wish to persist to a file. The `Env Var Prefix` denotes the prefix the environment variable should have. The environment variable is formatting is `<PREFIX>_<variable_name>`, e.g. `$env:ALZ_iac_type = "terraform"` or `$env:TF_VAR_github_personal_access_token = "*****..."`.
    {{< /hint >}}

    {{< hint type=tip >}}
If you followed our [phase 0 planning and decisions]({{< relref "../0_planning">}}) guidance, you should have these values already.
    {{< /hint >}}

    | Input | Env Var Prefix | Placeholder | Description |
    | - | - | -- | --- |
    | `iac_type` | `ALZ` | `terraform` | This is the choice of `bicep` or `terraform`. Keep this as `terraform` for this example. |
    | `bootstrap_module_name` | `ALZ` | `alz_github` | This is the choice of Version Control System. Keep this as `alz_github` for this example. |
    | `starter_module_name` | `ALZ` | `platform_landing_zone` | This is the choice of [Starter Modules]({{< relref "../../startermodules" >}}), which is the baseline configuration you want for your Azure landing zone. Choose `platform_landing_zone` for this example. |
    | `bootstrap_location` | `TF_VAR` | `<region>` | Replace `<region>` with the Azure region where you would like to deploy the bootstrap resources in Azure. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`. |
    | `starter_locations` | `TF_VAR` | `[<region-1>,<region-2>]` | Replace `<region-1>` and `<region-2>` with the Azure regions where you would like to deploy the starter module resources in Azure. This field expects the `name` of the regions in and array, such as `["uksouth", "ukwest"]`. You can find a full list of names by running `az account list-locations -o table`. |
    | `root_parent_management_group_id` | `TF_VAR` | `""` | This is the id of the management group that will be the parent of the management group structure created by the accelerator. If you are using the `Tenant Root Group` management group, you leave this as an empty string `""` or supply the tenant id. |
    | `subscription_id_management` | `TF_VAR` | `<management-subscription-id>` | Replace `<management-subscription-id>` with the id of the management subscription you created in the previous phase. |
    | `subscription_id_identity` | `TF_VAR` | `<identity-subscription-id>` | Replace `<identity-subscription-id>` with the id of the identity subscription you created in the previous phase. |
    | `subscription_id_connectivity` | `TF_VAR` | `<connectivity-subscription-id>` | Replace `<connectivity-subscription-id>` with the id of the connectivity subscription you created in the previous phase. |
    | `github_personal_access_token` | `TF_VAR` | `<token-1>` | Replace `<token-1>` with the `token-1` GitHub PAT you generated in a previous step. |
    | `github_runners_personal_access_token` | `TF_VAR` | `<token-2>` | Replace `<token-2>` with the `token-2` GitHub PAT you generated in the previous step specifically for the self-hosted runners. This only applies if you have `use_self_hosted_agents` set to `true`. You can set this to an empty string `""` if you are not using self-hosted runners. |
    | `github_organization_name` | `TF_VAR` | `<github-organization>` | Replace `<github-organization>` with the name of your GitHub organization. This is the section of the url after `github.com`. E.g. enter `my-org` for `https://github.com/my-org`. |
    | `use_separate_repository_for_templates` | `TF_VAR` | `true` | Determine whether to create a separate repository to store workflow templates as an extra layer of security. Set to `false` if you don't wish to secure your workflow templates by using a separate repository. This will default to `true`. |
    | `bootstrap_subscription_id` | `TF_VAR` | `""` | Enter the id of the subscription in which you would like to deploy the bootstrap resources in Azure. If left blank, the subscription you are connected to via `az login` will be used. In most cases this is the management subscription, but you can specifiy a separate subscription if you prefer. |
    | `service_name` | `TF_VAR` | `alz` | This is used to build up the names of your Azure and GitHub resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this. |
    | `environment_name` | `TF_VAR` | `mgmt` | This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this. |
    | `postfix_number` | `TF_VAR` | `1` | This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this. |
    | `use_self_hosted_agents` | `TF_VAR` | `true` | This controls if you want to deploy self-hosted agents. This will default to `true`. |
    | `use_private_networking` | `TF_VAR` | `true` | This controls whether private networking is deployed for your self-hosted agents and storage account. This only applies if you have `use_self_hosted_agents` set to `true`. This defaults to `true`. |
    | `allow_storage_access_from_my_ip` | `TF_VAR` | `false` | This controls whether to allow access to the storage account from your IP address. This is only needed for trouble shooting. This only applies if you have `use_private_networking` set to `true`. This defaults to `false`. |
    | `apply_approvers` | `TF_VAR` | `<email-address>` | This is a list of service principal names (SPN) of people you wish to be in the group that approves apply of the Azure landing zone module. This is an array of strings like `["abc@xyz.com", "def@xyz.com", "ghi@xyz.com"]`. You may need to check what the SPN is prior to filling this out as it can vary based on identity provider. Use empty array `[]` to disable approvals. Note if supplying via the user interface, use a comma separated string like `abc@xyz.com,def@xyz.com,ghi@xyz.com`. |
    | `create_branch_policies` | `TF_VAR` | `true` | This controls whether to create branch policies for the repository. This defaults to `true`. |
    | `architecture_definition_name` | `TF_VAR` | N/A | This is the name of the architecture definition to use when applying the ALZ archetypes via the architecture definition template. This is only relevant to some starter modules, such as the `sovereign_landing_zone` starter module. This defaults to `null`. |

1. Open your `platform-landing-zone.tfvars` file or keep your `inputs.yaml` file open for SLZ and FSI starter modules in Visual Studio Code (or your preferred editor)

1. Now head over to your chosen starter module documentation to get the specific inputs for that module.
    - [Terraform Azure Verified Modules for Platform Landing Zone (ALZ)]({{< relref "../../startermodules/terraform-platform-landing-zone" >}}): Management groups, policies, Multi Region hub networking with fully custom configuration.
    - [Terraform Financial Services Industry Landing Zone Starter Module]({{< relref "../../startermodules/terraformfsi" >}}): Management groups, policies, hub networking for the Financial Services Industry Landing Zone.
    - [Terraform Sovereign Landing Zone Starter Module]({{< relref "../../startermodules/terraformsovereign" >}}): Management groups, policies, hub networking for the Sovereign Landing Zone.

1. Verify that you are logged in to Azure CLI or have the Service Principal credentials set as env vars. You should have completed this in the [Prerequisites]({{< relref "../1_prerequisites" >}}) phase.
1. Ensure you are running the latest version of the ALZ PowerShell module by running:

    ```pwsh
    Update-Module -Name ALZ
    ```

1. In your PowerShell Core (pwsh) terminal run the module:

    {{< hint type=tip >}}
Inputs can be split into multiple files if desired.
    {{< /hint >}}

    - Run `Deploy-Accelerator` for the Azure Verified Modules for Platform Landing Zone (ALZ) starter module without a `lib` folder:

        {{< tabs "2" >}}
        {{< tab "Windows" >}}

```pwsh
Deploy-Accelerator `
  -inputs "c:\accelerator\config\inputs.yaml", "c:\accelerator\config\platform-landing-zone.tfvars" `
  -output "c:\accelerator\output"
```

        {{< /tab >}}
        {{< tab "Linux / macOS" >}}

```pwsh
Deploy-Accelerator `
  -inputs "./accelerator/config/inputs.yaml", "./accelerator/config/platform-landing-zone.tfvars" `
  -output "./accelerator/output"
```

        {{< /tab >}}
        {{< /tabs >}}

    * Run `Deploy-Accelerator` for the Azure Verified Modules for Platform Landing Zone (ALZ) starter module with a `lib` folder:

        {{< tabs "3" >}}
        {{< tab "Windows" >}}

```pwsh
Deploy-Accelerator `
  -inputs "c:\accelerator\config\inputs.yaml", "c:\accelerator\config\platform-landing-zone.tfvars" `
  -starterAdditionalFiles "c:\accelerator\config\lib" `
  -output "c:\accelerator\output"
```

        {{< /tab >}}
        {{< tab "Linux / macOS" >}}

```pwsh
Deploy-Accelerator `
  -inputs "./accelerator/config/inputs.yaml", "./accelerator/config/platform-landing-zone.tfvars" `
  -starterAdditionalFiles "./accelerator/config/lib" `
  -output "./accelerator/output"
```

        {{< /tab >}}
        {{< /tabs >}}

    * Run `Deploy-Accelerator` for the Sovereign Landing Zone or Financial Services Industry Landing Zone starter module:

        {{< tabs "4" >}}
        {{< tab "Windows" >}}

```pwsh
Deploy-Accelerator `
  -inputs "c:\accelerator\config\inputs.yaml" `
  -output "c:\accelerator\output"
```

        {{< /tab >}}
        {{< tab "Linux / macOS" >}}

```pwsh
Deploy-Accelerator `
  -inputs "./accelerator/config/inputs.yaml" `
  -output "./accelerator/output"
```

        {{< /tab >}}
        {{< /tabs >}}

1. You will see a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.

## Next Steps

Now head to [Phase 3]({{< relref "3_deploy" >}}).
