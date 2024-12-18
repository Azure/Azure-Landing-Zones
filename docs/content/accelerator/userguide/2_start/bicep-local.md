---
title: Local File System with Bicep
---

Follow these instructions to bootstrap a local file system folder ready to deploy your platform landing zone with Bicep.

1. Create a new folder on your local drive called `accelerator`.
1. Inside the accelerator create two folders called `config` and `output`. You'll store you input file inside config and the output folder will be the place that the accelerator stores files while it works.
1. Inside the `config` folder create a new file called `inputs.yaml`. You can use `json` if you prefer, but our examples here are `yaml`.

    ```pwsh
    # Windows
    New-Item -ItemType "file" c:\accelerator\config\inputs.yaml -Force
    New-Item -ItemType "directory" c:\accelerator\output

    # Linux/Mac
    New-Item -ItemType "file" /accelerator/config/inputs.yaml -Force
    New-Item -ItemType "directory" /accelerator/output
    ```

    ```plaintext
    📂accelerator
    ┣ 📂config
    ┃ ┗ 📜inputs.yaml
    ┗ 📂output
    ```

1. Open your `inputs.yaml` file in Visual Studio Code (or your preferred editor) and copy the content from [inputs-local.yaml](https://raw.githubusercontent.com/Azure/alz-bicep/refs/heads/main/accelerator/examples/bootstrap/inputs-local.yaml) into that file.
1. Check through the file and update each input as required. It is mandatory to update items with placeholders surrounded by angle brackets `<>`:

    {{< hint type=tip >}}
The following inputs can also be supplied via environment variables. This may be useful for sensitive values you don't wish to persist to a file. The `Env Var Prefix` denotes the prefix the environment variable should have. The environment variable is formatting is `<PREFIX>_<variable_name>`, e.g. `$env:ALZ_iac_type = "terraform"` or `$env:TF_VAR_github_personal_access_token = "*****..."`.
    {{< /hint >}}

    | Input | Env Var Prefix | Placeholder | Description |
    | - | - | -- | --- |
    | `iac_type` | `ALZ` | `bicep` | This is the choice of `bicep` or `terraform`. Keep this as `bicep` for this example. |
    | `bootstrap_module_name` | `ALZ` | `alz_local` | This is the choice of Version Control System. Keep this as `alz_local` for this example. |
    | `starter_module_name` | `ALZ` | `complete` | This is the choice of [Starter Modules][wiki_starter_modules], which is the baseline configuration you want for your Azure landing zone. Keep this as `complete` for this example. |
    | `bootstrap_location` | `TF_VAR` | `<region>` | Replace `<region>` with the Azure region where you would like to deploy the bootstrap resources in Azure. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`. |
    | `starter_locations` | `TF_VAR` | `[<region-1>,<region-2>]` | Replace `<region-1>` and `<region-2>` with the Azure regions where you would like to deploy the starter module resources in Azure. This field expects the `name` of the regions in and array, such as `["uksouth", "ukwest"]`. You can find a full list of names by running `az account list-locations -o table`. |
    | `root_parent_management_group_id` | `TF_VAR` | `""` | This is the id of the management group that will be the parent of the management group structure created by the accelerator. If you are using the `Tenant Root Group` management group, you leave this as an empty string `""` or supply the tenant id. |
    | `subscription_id_management` | `TF_VAR` | `<management-subscription-id>` | Replace `<management-subscription-id>` with the id of the management subscription you created in the previous phase. |
    | `subscription_id_identity` | `TF_VAR` | `<identity-subscription-id>` | Replace `<identity-subscription-id>` with the id of the identity subscription you created in the previous phase. |
    | `subscription_id_connectivity` | `TF_VAR` | `<connectivity-subscription-id>` | Replace `<connectivity-subscription-id>` with the id of the connectivity subscription you created in the previous phase. |
    | `target_directory` | `TF_VAR` | `""` | This is the directory where the ALZ module code will be created. This defaults a directory called `local-output` in the root of the accelerator output directory if not supplied. |
    | `create_bootstrap_resources_in_azure` | `TF_VAR` | `true` | This determines whether the bootstrap will create the bootstrap resources in Azure. This defaults to `true`. |
    | `bootstrap_subscription_id` | `TF_VAR` | `""` | Enter the id of the subscription in which you would like to deploy the bootstrap resources in Azure. If left blank, the subscription you are connected to via `az login` will be used. In most cases this is the management subscription, but you can specifiy a separate subscription if you prefer. |
    | `service_name` | `TF_VAR` | `alz` | This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this. |
    | `environment_name` | `TF_VAR` | `mgmt` | This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this. |
    | `postfix_number` | `TF_VAR` | `1` | This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this. |
    | `grant_permissions_to_current_user` | `TF_VAR` | `true` | This determines whether the bootstrap will grant the current user permissions to the management group structure created by the accelerator. This defaults to `true` so that the starter module can be immediately deployed from the local file system. Set this to `false` if you itend to wire up CI/CD with your own provider. |

1. Now head over to your chosen starter module documentation to get the specific inputs for that module. Come back here when you are done.
    - [Bicep Complete Starter Module][wiki_starter_module_bicep_complete]
1. In your PowerShell Core (pwsh) terminal run the module:

    ```pwsh
    # Windows (adjust the paths to match your setup)
    Deploy-Accelerator -inputs "c:\accelerator\config\inputs.yaml" -output "c:\accelerator\output"

    # Linux/Mac (adjust the paths to match your setup)
    Deploy-Accelerator -inputs "/accelerator/config/inputs.yaml" -output "/accelerator/output"
    ```

1. You will see a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.
1. You will find the output in the `/accelerator/output/local-output` folder if you didn't specifiy a different location for `target_directory`.

## Next Steps

Now head to [Phase 3]({{< relref "3_deploy" >}})