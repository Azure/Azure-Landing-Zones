---
title: Miscellaneous FAQ
weight: 100
---

## Questions about Multiple landing zone deployments

### I want to deploy multiple landing zones, but the PowerShell command keeps trying to overwrite my existing environment

After bootstrapping, the PowerShell leaves the folder structure intact, including the Terraform state file. This is by design, so you have an opportunity to amend or destroy the environment.

If you want to deploy to a separate environment, the simplest approach is to specify a separate folder for each deployment using the `-output` parameter. For example:

E.g. Your folder structure could look like this:

```plaintext
    📂accelerator
    ┣ 📂config
    ┃ ┣ 📂01
    ┃ ┃ ┃ 📜inputs.yaml
    ┃ ┃ ┗ 📜platform-landing-zone.tfvars
    ┃ ┗ 📂02
    ┃   ┃ 📜inputs.yaml
    ┃   ┗ 📜platform-landing-zone.tfvars
    ┣ 📂output01
    ┗ 📂output02
```

Your commands could look like this:

```powershell
# Environment 01
Deploy-Accelerator `
        -inputs "~/accelerator/config/01/inputs.yaml", "~/accelerator/config/01/platform-landing-zone.tfvars" `
        -starterAdditionalFiles "~/accelerator/config/01/lib" `
        -output "~/accelerator/output01"

# Environment 02
Deploy-Accelerator `
        -inputs "~/accelerator/config/02/inputs.yaml", "~/accelerator/config/02/platform-landing-zone.tfvars" `
        -starterAdditionalFiles "~/accelerator/config/02/lib" `
        -output "~/accelerator/output02"
```

You can then deploy as many times as you like without interfering with a previous deployment.

## Questions about Automating the PowerShell Module

### I get prompted to approve the Terraform plan, can I skip that?

Yes, you can skip the approval of the Terraform plan by using the `-autoApprove` parameter.

For example:

```powershell
Deploy-Accelerator `
        -inputs "~/accelerator/config/inputs.yaml", "~/accelerator/config/platform-landing-zone.tfvars" `
        -starterAdditionalFiles "~/accelerator/config/lib" `
        -output "~/accelerator/output" `
        -autoApprove
```

## Questions about GitHub

### How do I use a GitHub Enterprise Cloud with data residency (*.ghe.com) hosted instance?

In order to target your own domain, add the following settings to your bootstrap configuration file `inputs.yaml`:

```yaml
github_organization_domain_name: "<enterprise name>.ghe.com"
```

For example:

```yaml
github_organization_domain_name: "contoso.ghe.com"
```
