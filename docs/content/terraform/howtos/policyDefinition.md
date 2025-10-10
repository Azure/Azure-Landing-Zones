---
title: Developing Policy Definitions
weight: 2
---

{{< hint type=important >}}
You will need to have a [custom library]({{< relref "customLibrary" >}}) if you want to add or remove policy assets. If you've leveraged the bootstrap, this would've been created for you. 
Make sure you have completed that step before continuing.
{{< /hint >}}

The policy assets that are deployed to a given management group are defined in the [architecture definition](https://azure.github.io/Azure-Landing-Zones-Library/assets/architectures/) by the assigned [archetypes](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetypes/).

# Creating a Policy Definition

{{< hint type=tip >}}
This section is only for creating custom policy definitions. If you want to assign a built-in policy definition, you do not need to create a policy definition file as built-in policies are already available at all scopes. You can proceed directly to creating a [policy assignment]({{< relref "policyAssignment" >}}).
{{< /hint >}}

1. Navigate to your custom library directory (typically `lib` in your repository root).

2. Create a new file following the naming pattern `<mydefinition>.alz_policy_definition.json` or `<mydefinition>.alz_policy_definition.yaml`. It's recommend that the filename matches the `name` field in the policy definition, e.g. `My-Custom-Policy.alz_policy_definition.json`. Each asset must have a unique name so it can be indexed by the provider.

{{< hint type=tip >}}
Familiarize yourself with the idiomatic [library structure](https://azure.github.io/Azure-Landing-Zones-Library/#library-structure) and review existing policy definitions in the [ALZ Library](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_definitions) for reference.
{{< /hint >}}

3. Define your policy using the standard Azure Policy definition format. Here is an example policy definition in JSON format:

{{< highlight json "linenos=table" >}}
    {
      "name": "My-Custom-Policy",
      "type": "Microsoft.Authorization/policyDefinitions",
      "apiVersion": "2021-06-01",
      "properties": {
        "displayName": "My Custom Policy",
        "policyType": "Custom",
        "mode": "All",
        "description": "This is a custom policy definition",
        "metadata": {
          "version": "1.0.0",
          "category": "Custom"
        },
        "parameters": {},
        "policyRule": {
          "if": {
            "allOf": [
              {
                "field": "type",
                "equals": "Microsoft.Resources/subscriptions"
              }
            ]
          },
          "then": {
            "effect": "audit"
          }
        }
      }
    }
{{< / highlight >}}

## Create an Override Archetype

1. In your custom library directory, create or open an [override archetype](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetype-overrides/) file.

{{< hint type=tip >}}
Base archetypes must exist in your supplied library references. The [ALZ library](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/archetype_definitions) contains several archetypes that can be modified.
{{< /hint >}}

2. Add your policy definition name to the `policy_definitions_to_add` list in the override archetype.

{{< highlight yaml "linenos=table" >}}
    name: landing_zones_override
    base_archetype: landing_zones
    policy_assignments_to_add: []
    policy_assignments_to_remove: []
    policy_definitions_to_add:
      - My-Custom-Policy
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
{{< / highlight >}}

{{< hint type=tip >}}
Adding a policy definition to an archetype makes it available at that management group scope, but does not automatically assign it. You will need to create a [policy assignment]({{< relref "policyAssignment" >}}) separately to enforce the policy.
{{< /hint >}}

## Assign the Override Archetype to a Management Group

1. Create or update an [architecture definition](https://azure.github.io/Azure-Landing-Zones-Library/assets/architectures/) file in your custom library.

2. Reference your override archetype in the `archetypes` list for the target management group.

{{< highlight yaml "linenos=table" >}}
    name: alz_custom
    management_groups:
      # ... other management groups
      - id: landingzones
        display_name: Landing Zones
        archetypes:
          - landing_zones_override # This is referencing the archetype override file we created with the new policy definition.
        parent_id: my-root
        exists: false
{{< / highlight >}}

# Removing a Policy Definition

1. In your custom library directory, create or open an [override archetype](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetype-overrides/) file.

2. Add the policy definition name to the `policy_definitions_to_remove` list.

{{< highlight yaml "linenos=table" >}}
    name: landing_zones_override
    base_archetype: landing_zones
    policy_assignments_to_add: []
    policy_assignments_to_remove: []
    policy_definitions_to_add: []
    policy_definitions_to_remove:
      - My-Custom-Policy # This is the policy name I wish to remove 
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
{{< / highlight >}}

{{< hint type=tip >}}
If you remove a policy definition that is referenced by a policy assignment or policy set definition, the deployment will fail. Make sure to remove any dependent assets first.
{{< /hint >}}