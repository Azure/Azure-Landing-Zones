---
title: Updating Your Deployment
weight: 10
---

Keeping your Azure Landing Zone deployment up to date is important for security, compliance, and accessing new features. This guide covers how to update your deployment when new versions of the alz-bicep-accelerator templates are released.

## Understanding Updates

The alz-bicep-accelerator repository is regularly updated with:

- **New Azure Verified Modules (AVM) versions**: Updated module references with bug fixes and new features
- **New policy definitions**: Microsoft regularly releases new Azure Policy definitions
- **Policy assignment updates**: Changes to default policy assignments and parameters
- **Template improvements**: Enhancements to the Bicep templates themselves
- **Security patches**: Critical security updates

## Before You Update

Before updating your deployment, complete these steps:

### 1. Review Release Notes

Check the [alz-bicep-accelerator releases](https://github.com/Azure/alz-bicep-accelerator/releases) page for:

- Breaking changes that may impact your deployment
- New features and capabilities
- Required parameter changes
- Deprecated resources or configurations

### 2. Backup Your Configuration

Document or backup your current:

- Parameter files (`.bicepparam`)
- Custom policy definitions
- Custom role assignments
- Management group structure
- Any template modifications

### 3. Test in Non-Production

Always test updates in a non-production environment first:

1. Deploy the updated templates to a test tenant or management group
2. Validate policy compliance
3. Check for any breaking changes
4. Verify role assignments and permissions

## Update Process

### Step 1: Update Your Repository

If you're using Git to track your deployment:

```bash
# Pull the latest changes from the upstream repository
git fetch upstream
git merge upstream/main

# Or if you forked the repository
git pull origin main
```

If you're not using Git, download the latest release:

```bash
# Download the latest release
Invoke-WebRequest -Uri "https://github.com/Azure/alz-bicep-accelerator/archive/refs/heads/main.zip" -OutFile "alz-bicep-accelerator.zip"

# Extract the files
Expand-Archive -Path "alz-bicep-accelerator.zip" -DestinationPath "."
```

### Step 2: Review Template Changes

Compare the updated templates with your current deployment:

```bash
# Using Git to see what changed
git diff HEAD~1 HEAD -- templates/

# Or manually compare files
code --diff old-templates/main.bicep new-templates/main.bicep
```

Pay special attention to:

- Changes in parameter names or types
- New required parameters
- Deprecated or removed resources
- Changes in module versions

### Step 3: Update Your Parameter Files

Update your `.bicepparam` files to match any new or changed parameters:

```bicep
// Example: New parameter in updated template
param newLogRetentionDays int = 90

// Example: Renamed parameter
param logAnalyticsWorkspaceId string  // Previously: workspaceId
```

### Step 4: Validate Templates

Before deploying, validate your templates:

```bash
# Validate management group deployment
az deployment tenant validate \
  --location <location> \
  --template-file templates/core/governance/mgmt-groups/main.bicep \
  --parameters templates/core/governance/mgmt-groups/main.bicepparam

# Validate policy assignments
az deployment mg validate \
  --location <location> \
  --management-group-id <root-mg-id> \
  --template-file templates/core/governance/policyAssignments.bicep \
  --parameters templates/core/governance/policyAssignments.bicepparam
```

### Step 5: Deploy Updates

Deploy the updated templates in the same order as the initial deployment:

#### 1. Management Groups

```bash
az deployment tenant create \
  --location <location> \
  --template-file templates/core/governance/mgmt-groups/main.bicep \
  --parameters templates/core/governance/mgmt-groups/main.bicepparam
```

#### 2. Policy Definitions

```bash
az deployment mg create \
  --location <location> \
  --management-group-id <root-mg-id> \
  --template-file templates/core/governance/lib/alz/policyDefinitions.bicep \
  --parameters templates/core/governance/lib/alz/policyDefinitions.bicepparam
```

#### 3. Policy Assignments

```bash
az deployment mg create \
  --location <location> \
  --management-group-id <root-mg-id> \
  --template-file templates/core/governance/policyAssignments.bicep \
  --parameters templates/core/governance/policyAssignments.bicepparam
```

#### 4. Management Infrastructure

```bash
az deployment sub create \
  --location <location> \
  --subscription <management-subscription-id> \
  --template-file templates/core/logging/main.bicep \
  --parameters templates/core/logging/main.bicepparam
```

#### 5. Networking

```bash
az deployment sub create \
  --location <location> \
  --subscription <connectivity-subscription-id> \
  --template-file templates/networking/hubnetworking/main.bicep \
  --parameters templates/networking/hubnetworking/main.bicepparam
```

### Step 6: Verify Deployment

After deployment, verify:

1. **Policy Compliance**: Check Azure Policy compliance in the portal
2. **Resources**: Verify all expected resources are deployed
3. **Role Assignments**: Confirm policy managed identities have correct permissions
4. **Networking**: Test connectivity if networking components were updated
5. **Monitoring**: Check that monitoring and alerting are functioning

## Handling Breaking Changes

If the update includes breaking changes:

### Parameter Removals or Renames

Update your parameter files to use the new parameter names:

```bicep
// Old parameter file
param workspaceId string = '/subscriptions/.../workspaces/my-workspace'

// New parameter file
param logAnalyticsWorkspaceId string = '/subscriptions/.../workspaces/my-workspace'
```

### Resource Replacements

Some updates may require resource recreation:

1. **Review impact**: Understand what will be replaced
2. **Plan downtime**: Schedule updates during maintenance windows
3. **Backup data**: Export any data that needs preservation
4. **Update references**: Update any resources that reference the old resource

### Module Version Updates

When AVM modules are updated:

1. Review the [AVM module changelog](https://aka.ms/avm)
2. Check for breaking changes in the module
3. Update module references in your templates
4. Test thoroughly before production deployment

## Automated Updates with CI/CD

If you're using CI/CD pipelines:

### GitHub Actions Example

```yaml
name: Update ALZ Deployment

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:  # Manual trigger

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Azure Login
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Validate Templates
        run: |
          az deployment tenant validate \
            --location eastus \
            --template-file templates/core/governance/mgmt-groups/main.bicep \
            --parameters templates/core/governance/mgmt-groups/main.bicepparam

      - name: Deploy Updates
        run: |
          az deployment tenant create \
            --location eastus \
            --template-file templates/core/governance/mgmt-groups/main.bicep \
            --parameters templates/core/governance/mgmt-groups/main.bicepparam
```

### Azure DevOps Pipeline Example

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - task: AzureCLI@2
    displayName: 'Validate Templates'
    inputs:
      azureSubscription: 'Azure Service Connection'
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment tenant validate \
          --location eastus \
          --template-file templates/core/governance/mgmt-groups/main.bicep \
          --parameters templates/core/governance/mgmt-groups/main.bicepparam

  - task: AzureCLI@2
    displayName: 'Deploy Updates'
    inputs:
      azureSubscription: 'Azure Service Connection'
      scriptType: 'bash'
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment tenant create \
          --location eastus \
          --template-file templates/core/governance/mgmt-groups/main.bicep \
          --parameters templates/core/governance/mgmt-groups/main.bicepparam
```

## Best Practices

1. **Stay Current**: Regularly check for updates, at least monthly
2. **Use Semantic Versioning**: Tag your deployments with version numbers
3. **Maintain Change Log**: Document what was updated and when
4. **Automated Testing**: Implement automated validation in your CI/CD pipeline
5. **Rollback Plan**: Have a plan to revert changes if issues occur
6. **Communicate Changes**: Notify stakeholders before major updates
7. **Monitor After Updates**: Watch for issues in the hours following an update

## Troubleshooting Updates

### Deployment Fails After Update

1. Check validation output for specific errors
2. Review template changes for breaking changes
3. Verify parameter values are correct
4. Check Azure Activity Log for detailed error messages

### Policy Compliance Issues

1. Verify policy definitions were updated successfully
2. Check policy assignment parameters
3. Ensure managed identities have correct role assignments
4. Trigger manual policy evaluation if needed

### Resource Conflicts

1. Check for resources that already exist
2. Review resource naming conventions
3. Verify deployment scopes are correct
4. Check for locks on existing resources

## Getting Help

If you encounter issues during updates:

- Review the [alz-bicep-accelerator issues](https://github.com/Azure/alz-bicep-accelerator/issues)
- Check the [Azure Landing Zones documentation](https://aka.ms/alz)
- Ask questions in the [Azure Landing Zones discussions](https://github.com/Azure/Enterprise-Scale/discussions)
- Contact Microsoft Support for critical issues
