---
title: 1. Management components
draft: true
---

Core to Azure Landing Zones is the concept of centralized logging.
We recommend beginning with the deployment of the management components, which include the following:

- **Log Analytics workspace**: Used to collect and analyze logs from Azure resources.
- **Automation account**: (Optional) Used to automate tasks in Azure.
- **Azure Monitor Agent Resources**: The identity and data collection rules required for AMA.

We have a Terraform module that deploys these resources for you: <https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest>

## Getting started

First let's create a `terraform.tf` file in a new directory and add the following code:

{{< include file="/static/examples/tf/1_management/terraform.tf" language="terraform" >}}

Here we specify the minimum version of Terraform we want to use.
We set [pessimistic version constraints](https://developer.hashicorp.com/terraform/language/expressions/version-constraints) to allow only the minor version to change.
This will prevent a new major version from being used, which could introduce breaking changes.

## Add the ALZ Management module

{{< hint type=warning title="Cost Warning" >}}
You will incur costs for the data collected in the Log Analytics workspace.
Set a value for the [`log_analytics_workspace_daily_quota_gb`](https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest#input_log_analytics_workspace_daily_quota_gb) input in order to have a predictable cost.

However, you should use care when setting a daily cap because when data collection stops, your ability to observe and receive alerts when the health conditions of your resources will be impacted.
{{< /hint >}}

Create a file called `main.tf` in the same directory and add the following code:

{{< include file="/static/examples/tf/1_management/main.tf" language="terraform" >}}

## Plan and apply

We recommend using CI/CD to deploy your infrastructure, the [Accelerator]({{< relref "../../accelerator" >}}) is a great way to get started with this.
However you can also run Terraform locally:

Run `terraform init` to download the module and initialize the directory.
Next, run `terraform plan` to see what resources will be created.
Finally, run `terraform apply` to create the resources.

## Next Steps

Add networking components to your Azure Landing Zone by following the [Networking]({{< relref "terraform/2_networking/" >}}) guide.
