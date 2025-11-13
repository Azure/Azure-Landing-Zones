---
title: Updating the Release Version
weight: 10
---

This guide outlines the steps to update the release version of the [Azure Landing Zones Bicep](https://github.com/Azure/ALZ-Bicep) modules used in your Accelerator framework.

We recommend updating to the latest minor or patch version of the ALZ Bicep modules to take advantage of bug fixes, new features, and ongoing improvements.

However, if you’re part of a smaller team or organization, you may choose to skip some minor releases and instead adopt only the latest major version when you're ready to incorporate the broader changes. Additionally, we publish quarterly policy updates, and some customers choose to align their release version updates with that cadence to stay current with platform governance standards. Just be aware that skipping versions may require additional review of release notes and complexity to ensure compatibility with your existing configurations.

{{< hint type=important >}}
Before you begin, read the [ALZ Bicep release notes](https://github.com/Azure/ALZ-Bicep/releases) to understand any breaking changes or new features that could impact your deployment—especially if upgrading to a new **major** version.
{{< /hint >}}

## Step One – Update the `parameters.json` File

In your cloned **primary** repository (not the `templates` repository, if `use_separate_repository_for_templates` was set to `true` during Accelerator bootstrapping), navigate to the root directory and open the `parameters.json` file.

## Step Two – Set the New Release Version

In the `parameters.json` file, locate the `RELEASE_VERSION` parameter and update it to the desired version from the [Azure Landing Zones Bicep releases](https://github.com/Azure/ALZ-Bicep/releases).

Example:

```json
"RELEASE_VERSION": "v0.22.3"
```

## Step Three – Review and Update Module Parameters (if needed)

If the new release introduces changes to module parameters, you may need to update your configuration files to reflect those changes.

Check the release notes or module documentation to determine whether any inputs have been added, renamed, or removed.

You can find your module-specific parameter files in the following directory: `config\custom\parameters\`

{{< hint type=important >}}
If you are skipping release versions (e.g., going from `v0.22.1` to `v0.23.3`), ensure you review the release notes for all skipped versions to identify any changes that may affect your deployment.
{{< /hint >}}

## Step Four – Commit and Push Your Changes

After making updates to the `parameters.json` file and any necessary module parameter files, commit and push your changes to your upstream repository (e.g., Azure DevOps or GitHub).

Use the following Git commands:

```bash
git add parameters.json
git add config/custom/parameters/*
git commit -m "Update ALZ Bicep release version to <new_version>"
git push
```

## Step Five – Create a Pull Request

After pushing your changes, open a pull request (PR) in your primary repository to merge the updates into the `main` branch.

This PR allows your team to:

- Review the changes.
- Validate them using the automated `what-if` analysis built into the CI (01 Azure Landing Zones Continuous Integration) pipeline/workflow.
- Ensure the updated release version and parameter changes will not introduce unexpected changes to the environment.

Use clear commit messages and PR titles like:

`chore: update ALZ Bicep release version to v0.22.3chore: update ALZ Bicep release version to v0.22.3`

Once reviewed and approved, the PR can be safely merged.

## Step Six – Deploy the Updated Modules

Once the pull request is approved and merged into the `main` branch:

- The `02 Azure Landing Zones Continuous Delivery` pipeline/workflow will be automatically triggered.
- This pipeline/workflow will perform a `what-if` analysis to preview changes.
- If no issues are detected, it will proceed to deploy the updated Azure Landing Zones Bicep modules to your Azure environment.

{{< hint type=note >}}
If you have approvers configured for the `02 Azure Landing Zones Continuous Delivery` pipeline/workflow, you will need to wait for them to approve the deployment before it proceeds with the actual deployment.

You may also need to manually trigger the pipeline/workflow if it does not automatically run after the pull request is merged, depending on your pipeline/workflow triggers.
{{< /hint >}}
