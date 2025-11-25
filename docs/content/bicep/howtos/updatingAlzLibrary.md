---
title: Updating the ALZ Library Version
weight: 10
---

The ALZ (Azure Landing Zones) library contains Microsoft-provided policy definitions, policy set definitions, role definitions, and policy assignments. This library is updated regularly with new policies, security improvements, and best practices.

{{< hint type=warning >}}
**IMPORTANT: Read Release Notes Before Updating**

Always review both the [Azure Landing Zones Library release notes](https://github.com/Azure/Azure-Landing-Zones-Library/releases) and the [alz-bicep-accelerator release notes](https://github.com/Azure/alz-bicep-accelerator/releases) before updating the ALZ library version.

Release notes contain critical information about:

- **Breaking changes** that may require parameter file modifications
- **Deprecated policies** that need to be removed from your configuration
- **New required parameters** for policy assignments
- **Renamed or restructured policies** that affect your deployments
- **Migration steps** needed for major version updates

Skipping this step may result in deployment failures or unexpected policy behavior.
{{< /hint >}}

## Understanding the ALZ Library Structure

The ALZ library is located in `templates/core/governance/lib/alz/` and contains:

- **alz/** - Microsoft-provided ALZ policies, policy sets, role definitions, and policy assignments
  - Organized by management group scope (root, platform, landingzones, sandbox, decommissioned)
  - Files are named with suffixes: `.alz_policy_definition.json`, `.alz_policy_set_definition.json`, `.alz_role_definition.json`, `.alz_policy_assignment.json`
- **customer/** (optional) - Your organization's custom policies

{{< hint type=important >}}
The `alz/` directory contains **only** Microsoft-provided ALZ policies. Do not manually edit files in this directory as they will be overwritten during library updates.

For custom policies, create a `customer/` directory next to the `alz/` directory and use the `customerPolicyDefs`, `customerPolicySetDefs`, and `customerPolicyAssignments` arrays in your `.bicepparam` files.
{{< /hint >}}

## Library Version Management

The ALZ library version is managed through the `alz_library_metadata.json` file located in `templates/core/governance/tooling/`:

```json
{
  "$schema": "https://raw.githubusercontent.com/Azure/Azure-Landing-Zones-Library/main/schemas/library_metadata.json",
  "name": "local",
  "display_name": "ALZ Accelerator - Azure Verified Modules for ALZ Platform Landing Zone",
  "description": "This library allows overriding policies, archetypes, and management group architecture in the ALZ Accelerator.",
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "2025.09.2"
    }
  ]
}
```

The `ref` field specifies the version of the [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library) to use.

## Prerequisites

Before updating the ALZ library, ensure you have:

- **alzlibtool.exe** - Located in `templates/core/governance/tooling/`
- **PowerShell 7.0 or later** - Required for the update script
- **Git** (optional) - To review changes before committing

## Update Process

### Step 1: Review Release Notes and Check for Breaking Changes

{{< hint type=important >}}
This is the **most critical step** in the update process. Do not skip it.
{{< /hint >}}

Before proceeding with any update, thoroughly review the release notes from both repositories:

#### Azure Landing Zones Library Release Notes

Visit the [Azure Landing Zones Library releases](https://github.com/Azure/Azure-Landing-Zones-Library/releases) page and review:

- **Breaking Changes** - Pay special attention to:
  - Policy assignments that have been renamed or removed
  - Required parameter changes for existing policies
  - Changes to policy definition IDs or names
  - Modifications to role requirements for policy managed identities
- **New Policy Definitions** - Identify policies that may require:
  - New parameter values (e.g., Log Analytics workspace IDs)
  - Additional role assignments for managed identities
  - Updates to your exclusion lists if not applicable
- **Deprecated Policies** - Note policies that need to be:
  - Removed from custom exclusion lists
  - Replaced with newer alternatives
  - Unassigned before the update
- **Security Updates** - Understand new compliance requirements

#### alz-bicep-accelerator Release Notes

Visit the [alz-bicep-accelerator releases](https://github.com/Azure/alz-bicep-accelerator/releases) page and review:

- **Template Changes** - Changes to `.bicep` or `.bicepparam` structure
- **Parameter Schema Updates** - New or modified parameter requirements
- **Breaking Changes** - Updates that require manual intervention
- **Migration Guides** - Step-by-step instructions for major version updates

### Step 2: Update the Library Metadata

Edit `templates/core/governance/tooling/alz_library_metadata.json` and update the `ref` field to the desired version:

```json
{
  "dependencies": [
    {
      "path": "platform/alz",
      "ref": "2025.11.0"  // Update to new version
    }
  ]
}
```

### Step 3: Clear the Existing ALZ Library

Remove the current ALZ library directory (the alzlibtool will regenerate it):

```powershell
# Navigate to the lib directory
cd C:\Path\To\templates\core\governance\lib

# Remove the alz directory
Remove-Item -Path ".\alz" -Recurse -Force
```

{{< hint type=warning >}}
Only delete the `alz/` directory. Do **not** delete the `customer/` directory if you have custom policies.
{{< /hint >}}

### Step 4: Regenerate the ALZ Library

Use the `alzlibtool.exe` to regenerate the library from the Azure Landing Zones Library repository:

```powershell
# Navigate to the tooling directory
cd C:\Path\To\templates\core\governance\tooling

# Run alzlibtool to generate the library
.\alzlibtool.exe generate architecture `
  "C:\Path\To\templates\core\governance\tooling" `
  alz `
  --for-alz-bicep `
  -o "C:\Path\To\templates\core\governance\lib"
```

**Command breakdown:**

- `generate architecture` - Generate library files from an architecture definition
- First path - Location of the `alz_library_metadata.json` file
- `alz` - The architecture name to generate
- `--for-alz-bicep` - Format output for ALZ Bicep accelerator
- `-o` - Output directory (the lib folder)

The tool will:

1. Read the version from `alz_library_metadata.json`
1. Download the specified version from the Azure Landing Zones Library GitHub repository
1. Generate policy definitions, policy set definitions, role definitions, and policy assignments
1. Organize files by management group scope

### Step 5: Update Bicep Module References

After regenerating the library, run the `Update-AlzLibraryReferences.ps1` script to update the `loadJsonContent()` references in all management group `main.bicep` files:

```powershell
# Navigate to the tooling directory
cd C:\Path\To\templates\core\governance\tooling

# Run the update script
.\Update-AlzLibraryReferences.ps1
```

The script will:

- Scan each management group's library directory
- Update the `alzRbacRoleDefsJson`, `alzPolicyDefsJson`, `alzPolicySetDefsJson`, and `alzPolicyAssignmentsJson` arrays
- Show a detailed summary of changes for each module
- Preserve any custom entries in the arrays

**Script options:**

```powershell
# Preview changes without applying them
.\Update-AlzLibraryReferences.ps1 -WhatIf

# Update a specific module only
.\Update-AlzLibraryReferences.ps1 -ModulePath "../mgmt-groups/int-root/main.bicep"

# Use custom library path
.\Update-AlzLibraryReferences.ps1 -AlzLibraryRoot "C:\Custom\Path\lib\alz"
```

### Step 6: Review Changes

Review the changes made to your Bicep files:

```powershell
# If using Git, review changes
git diff templates/core/governance/mgmt-groups/*/main.bicep

# Check specific module for new policies
cat templates/core/governance/mgmt-groups/int-root/main.bicep | Select-String "alz_policy"
```

Pay attention to:

- **New policy definitions** that may require parameters
- **Updated policy assignments** that may need parameter values
- **Removed or renamed policies** that may affect your configuration
- **New policy set definitions** (initiatives) that bundle multiple policies

### Step 7: Update Parameter Overrides

If new policy assignments require parameters (like Log Analytics workspace IDs), update your `.bicepparam` files:

**int-root/main.bicepparam:**

```bicep-params
param parPolicyAssignmentParameterOverrides = {
  'New-Policy-Assignment-Name': {
    parameters: {
      logAnalytics: {
        value: '/subscriptions/<subscription-id>/resourcegroups/rg-alz-logging-eastus/providers/Microsoft.OperationalInsights/workspaces/law-alz-eastus'
      }
    }
  }
  // ... existing overrides
}
```

### Step 8: Commit Changes and Create Pull Request

Commit your changes to a feature branch and create a pull request:

```powershell
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "chore: Update ALZ library to version 2025.11.0"

# Push to remote branch
git push origin feature/update-alz-library
```

Create a pull request in your repository (GitHub or Azure DevOps).

### Step 9: Automated CI Validation

The ALZ accelerator includes automated CI/CD pipelines that will automatically run when you create a pull request:

**Continuous Integration (CI) Pipeline:**

1. **Bicep Build & Lint** - Validates all Bicep files compile successfully
2. **What-If Analysis** - Runs `New-AzManagementGroupDeployment -WhatIf` for each management group to show:
   - Resources that will be created
   - Resources that will be modified
   - Resources that will be deleted
   - Policy assignments that will be added or updated

{{< hint type=note >}}
The What-If analysis uses standard Azure deployments with the `-WhatIf` parameter, not deployment stacks, because deployment stacks don't support what-if operations yet.
{{< /hint >}}

**Review the CI Pipeline Results:**

- Check the pipeline output for any validation errors
- Review the What-If results to understand what will change
- Look for:
  - New policy definitions being added
  - Policy assignments being updated with new parameters
  - Deprecated policies being removed (if applicable)
  - Any unexpected changes that may indicate parameter issues

**For GitHub Actions:**

```yaml
# Workflow: 01 Azure Landing Zones Continuous Integration
# Triggered on: Pull Request to main branch
# Permissions: id-token (write), contents (read), pull-requests (write)
```

**For Azure DevOps Pipelines:**

```yaml
# Pipeline: ALZ-Bicep-CI
# Triggered on: Pull Request to main branch
# Stages: Validate, WhatIf
```

### Step 10: Review and Merge Pull Request

Once the CI pipeline passes:

1. **Review the What-If output** carefully for each management group
2. **Verify parameter overrides** are correctly configured for new policies
3. **Check for breaking changes** highlighted in the What-If results
4. **Get approval** from team members if required
5. **Merge the pull request** to the main branch

### Step 11: Automated CD Deployment with Deployment Stacks

After merging to main, the Continuous Delivery (CD) pipeline automatically deploys using **Azure Deployment Stacks**:

**Deployment Process:**

1. **What-If Check** (optional, can be skipped for urgent updates)
   - Runs a final what-if analysis on the main branch
   - Provides last-minute validation before deployment

2. **Deployment Stack Execution**
   - Uses `New-AzManagementGroupDeploymentStack` for each management group
   - Deployed in the correct order: int-root → child MGs → logging → networking
   - Each deployment uses:
     - `ActionOnUnmanage: DeleteAll` - Automatically removes resources no longer in template
     - `DenySettingsMode: None` - Allows policy remediation and updates
     - Automatic retry logic with exponential backoff

{{< hint type=important >}}
**Deployment Stacks Automatic Cleanup**

Unlike classic Bicep deployments, deployment stacks automatically remove resources that are no longer defined in your templates. This means:

- **Deprecated policies are automatically unassigned** when you update the ALZ library
- **No manual cleanup required** for removed policy assignments
- **Consistent state** between your templates and deployed resources
- **Safe deletion** - only removes resources managed by the deployment stack

This is a major improvement over ALZ Bicep Classic, where you had to manually remove deprecated policy assignments before deploying updates.
{{< /hint >}}

Verify:

1. All deployment stacks completed successfully
2. Policy definitions were created/updated
3. Policy assignments have correct parameters
4. Deprecated policies were automatically removed
5. No unexpected compliance errors for existing compliant resources

## Working with Custom Policies

To add your own custom policies alongside Microsoft ALZ policies:

### Create a Customer Directory

```powershell
# Create customer directory structure
New-Item -Path "templates\core\governance\lib\customer" -ItemType Directory -Force

# Create subdirectories for different scopes (optional)
New-Item -Path "templates\core\governance\lib\customer\platform" -ItemType Directory -Force
New-Item -Path "templates\core\governance\lib\customer\landingzones" -ItemType Directory -Force
```

### Add Custom Policy Files

Place your custom policy files in the customer directory using the same naming convention:

- `MyCustom-Policy.alz_policy_definition.json`
- `MyCustom-Initiative.alz_policy_set_definition.json`
- `MyCustom-Assignment.alz_policy_assignment.json`
- `MyCustom-Role.alz_role_definition.json`

### Reference Custom Policies in Bicep

Custom policies are **not** automatically loaded. You must explicitly add them to your `.bicepparam` files:

**int-root/main.bicepparam:**

```bicep-params
param intRootConfig = {
  // ... other config

  customerPolicyDefs: [
    {
      name: 'MyCustom-Policy'
      properties: {
        policyType: 'Custom'
        displayName: 'My Custom Policy'
        mode: 'All'
        policyRule: { /* policy rules */ }
      }
    }
  ]

  customerPolicySetDefs: [
    {
      name: 'MyCustom-Initiative'
      properties: {
        policyType: 'Custom'
        displayName: 'My Custom Initiative'
        policyDefinitions: [ /* policy refs */ ]
      }
    }
  ]

  customerPolicyAssignments: [
    {
      name: 'MyCustom-Assignment'
      properties: {
        policyDefinitionId: '/providers/Microsoft.Management/managementGroups/alz/providers/Microsoft.Authorization/policyDefinitions/MyCustom-Policy'
        scope: '/providers/Microsoft.Management/managementGroups/alz'
      }
    }
  ]
}
```

## Related Documentation

- [Modifying Policy Assignments]({{< relref "modifyingPolicyAssignments" >}}) - How to customize policy parameters
- [Modifying Management Group Hierarchy]({{< relref "modifyingMgHierarchy" >}}) - Customizing management groups
- [Azure Landing Zones Library](https://github.com/Azure/Azure-Landing-Zones-Library) - Source library repository
