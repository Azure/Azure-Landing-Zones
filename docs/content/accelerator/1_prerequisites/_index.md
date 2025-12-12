---
title: Phase 1 - Prerequisites
geekdocCollapseSection: true
weight: 20
---

Set up the prerequisites by following the steps below.

## 1 - Tools and Internet Access

Install the following tools before getting started.

- PowerShell 7.4 (or newer): [Follow the instructions for your operating system](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- Azure CLI 2.55.0 (or newer): [Follow the instructions for your operating system](https://learn.microsoft.com/cli/azure/install-azure-cli)
* Git (any supported version): [Follow the instructions for your operating system](https://git-scm.com/downloads).

{{< hint type=note >}}
Ensure all tools are available from a PowerShell Core (pwsh) terminal. Add them to your environment path if needed.
{{< /hint >}}

You also need internet access to download tools, Terraform providers, and connect to Azure and your VCS.

We **DO NOT** explicitly support:

* Running behind a corporate proxy
* Running in Azure Cloud Shell

{{< hint type=tip >}}
If your local machine is behind a corporate proxy, consider spinning up a temporary VM in Azure to run the Accelerator from, then tear it down when you are done.
{{< /hint >}}

## 2 - Azure Subscriptions and Permissions

Follow the instructions in the [Platform Subscriptions and Permissions]({{< relref "platform-subscriptions" >}}) section.

## 3 - Version Control Systems

Choose GitHub, Azure DevOps, or Local File System and follow the relevant steps:

### Azure DevOps

Follow the instructions in the [Azure DevOps]({{< relref "azuredevops" >}}) section.

### GitHub

Follow the instructions in the [GitHub]({{< relref "github" >}}) section.

### Local File System

Ensure you have a folder accessible from your current session.

## Next Steps

Now head to [Phase 2]({{< relref "2_bootstrap" >}}).
