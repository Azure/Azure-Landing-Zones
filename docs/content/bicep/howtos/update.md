---
title: Updating Your Deployment
weight: 10
---

Keeping your Azure Landing Zone deployment up to date is important for security, compliance, and accessing new features. This guide covers how to update your deployment when new versions of the alz-bicep-accelerator templates are released.

## Understanding Updates

The Bicep AVM framework differs from Classic Bicep in how modules are managed. During bootstrap, the entire `templates` directory with all Azure Verified Modules is pushed to your repository. This means:

- **You control module updates**: Update AVM modules in your templates directory as new versions are released
- **No on-demand pulling**: Unlike Classic Bicep which pulls modules from specific release versions on demand, you manage the module versions directly
- **Direct AVM updates**: Monitor [Azure Verified Modules](https://aka.ms/avm) releases and update module references in your templates as needed for new features or fixes

### Module Issues and Support

If you encounter issues:

- **Framework issues**: Submit to [alz-bicep-accelerator issues](https://github.com/Azure/alz-bicep-accelerator/issues) for problems with the ALZ framework
- **Module issues**: Submit to [bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) for issues with underlying AVM modules themselves

## Update Process

Since the templates directory is included in your repository during bootstrap, you can update AVM modules independently:

1. **Check for new module versions**: Monitor the [Azure Verified Modules](https://aka.ms/avm) releases
2. **Update module references**: Modify the module references in your Bicep templates to use newer versions
3. **Test the changes**: Validate and test in non-production before deploying to production
4. **Use CI/CD pipelines**: The provided GitHub Actions workflows and Azure DevOps pipelines handle deployment and validation automatically

### Step 1: Update Module Versions

Update the AVM module references in your templates directory:

```bicep
// Example: Update module version in your template
module hubNetwork 'br/public:avm/res/network/virtual-network:0.2.0' = {
  // Update to newer version
  // 'br/public:avm/res/network/virtual-network:0.3.0'
  name: 'hubNetworkDeployment'
  params: {
    // parameters
  }
}
```

Check the [AVM module documentation](https://aka.ms/avm) for:

- Version compatibility
- Breaking changes
- New features and parameters
- Bug fixes

### Step 2: Review Template Changes

Review any changes you're making to your templates to ensure compatibility:

- Changes in parameter names or types
- New required parameters
- Deprecated or removed resources
- Changes in module versions

### Step 3: Validate and Deploy with CI/CD

The bootstrap process includes CI/CD pipelines (GitHub Actions or Azure DevOps) that handle validation and deployment automatically:

**GitHub Actions**: Workflows validate templates and deploy changes when you push to your repository

**Azure DevOps**: Pipelines automatically validate and deploy updates through your defined stages

The pipelines will:

1. Validate Bicep templates for syntax and errors
2. Run deployment previews (what-if analysis)
3. Deploy to target environments based on your approval gates
4. Verify deployment success

Simply commit your template changes and push to trigger the automated validation and deployment process.

## Verify Deployment

After updates are deployed through CI/CD:

1. **Policy Compliance**: Check Azure Policy compliance in the portal
2. **Resources**: Verify all expected resources are deployed
3. **Role Assignments**: Confirm policy managed identities have correct permissions
4. **Networking**: Test connectivity if networking components were updated
5. **Monitoring**: Check that monitoring and alerting are functioning

## Handling Breaking Changes

When updating AVM modules, you may encounter breaking changes:

### Module Version Updates

When AVM modules are updated:

1. Review the [AVM module changelog](https://aka.ms/avm) for the specific module
2. Check for breaking changes in parameters, outputs, or behavior
3. Update module references in your templates to the new version
4. Update any parameter values that have changed
5. Test thoroughly in non-production before deploying to production

### Parameter Changes

If a module update includes parameter changes:

```bicep
// Old module version
module network 'br/public:avm/res/network/virtual-network:0.1.0' = {
  params: {
    vnetName: 'hub-vnet'  // Old parameter name
  }
}

// New module version
module network 'br/public:avm/res/network/virtual-network:0.2.0' = {
  params: {
    name: 'hub-vnet'  // New parameter name
  }
}
```

### Resource Replacements

Some module updates may require resource recreation:

1. **Review impact**: Check what resources will be replaced using `az deployment what-if`
2. **Plan downtime**: Schedule updates during maintenance windows if needed
3. **Backup data**: Export any data that needs preservation
4. **Update references**: Update any resources that reference the replaced resource

## CI/CD Pipeline Updates

The bootstrap process provides CI/CD pipelines that automatically handle deployment validation and execution. The pipelines are included in your repository:

### GitHub Actions

The `.github/workflows` directory contains workflows that:

- Validate Bicep template syntax
- Run `az deployment what-if` to preview changes
- Deploy to Azure based on branch and approval gates
- Provide deployment status and logs

When you push changes to your repository, the workflows automatically trigger validation and deployment.

### Azure DevOps Pipelines

The Azure DevOps pipelines in your repository:

- Validate templates before deployment
- Execute what-if analysis
- Deploy through defined stages (e.g., dev → test → prod)
- Include approval gates for production deployments

The pipelines handle all validation and deployment logic, so you can focus on updating your templates.

## Best Practices

1. **Monitor AVM Releases**: Regularly check [Azure Verified Modules](https://aka.ms/avm) for updates to modules you're using
2. **Test Module Updates**: Always test new module versions in non-production environments first
3. **Use Semantic Versioning**: Pin specific module versions in your templates for consistency
4. **Review Changelogs**: Check module changelogs for breaking changes before updating
5. **Leverage CI/CD**: Let the provided pipelines handle validation and deployment
6. **Maintain Documentation**: Document which module versions you're using and why
7. **Monitor After Updates**: Watch for issues after deploying module updates

## Troubleshooting Updates

### Deployment Fails After Update

1. Check the CI/CD pipeline logs for specific errors
2. Review module changes for breaking changes
3. Verify parameter values match the new module version requirements
4. Check Azure Activity Log for detailed error messages
5. Run `az deployment what-if` to preview changes before deploying

### Module-Specific Issues

If you believe an issue is with an underlying AVM module (not the ALZ framework):

1. Identify the specific AVM module causing the issue
2. Check the module's repository in [bicep-registry-modules](https://github.com/Azure/bicep-registry-modules)
3. Review existing issues for the module
4. Submit a new issue to the bicep-registry-modules repository for the module owner to address

### Policy Compliance Issues

1. Verify policy definitions were updated successfully
2. Check policy assignment parameters
3. Ensure managed identities have correct role assignments
4. Trigger manual policy evaluation if needed

### Resource Conflicts

1. Check for resources that already exist with the same name
2. Review resource naming conventions
3. Verify deployment scopes are correct
4. Check for locks on existing resources

## Getting Help

If you encounter issues during updates:

- **General Guidance and Framework Issues**: Check the [Azure Landing Zones documentation](https://aka.ms/alz/acc)
- **Module Issues**: Submit to [bicep-registry-modules](https://github.com/Azure/bicep-registry-modules) for the specific module
