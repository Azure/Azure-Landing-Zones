---
title: Modifying policy assets (archetypes)
---

{{< hint type=important >}}
You will need to have a [custom library]({{< relref "customLibrary" >}}) if you want to add or remove policy assets.
Make sure you have completed that step before continuing.
{{< /hint >}}

The policy assets that are deployed to a given management group are defined in the [architecture definition](https://azure.github.io/Azure-Landing-Zones-Library/assets/architectures/) by the assigned [archetypes](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetypes/).

If you want to add or remove policy assets, you will need to follow the following steps in your custom library:

1. Create any required new assets, e.g. assignments, definitions, etc.
1. Create an [override archetype](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetype-overrides/)
1. Assign the override archetype to the management group(s) you want to modify

## Step one - Create new assets

If you want to add new policy assets, you will first need to create them in your custom library.

You should familiarize yourself with the idiomatic [library structure](https://azure.github.io/Azure-Landing-Zones-Library/#library-structure) before continuing.

Which assets you need to create depends on what you want to achieve:

###  Assigning a built-in policy definition

Create a `<myassignment>.alz_policy_assignment.json` (or YAML) file in your custom library.
This file should reference the built-in definition that you want to assign.
We recommend copying one of the assignments in the [Library](https://github.com/Azure/Azure-Landing-Zones-Library/tree/main/platform/alz/policy_assignments) as a starting point.

{{< hint type=note >}}
Each asset must have a unique name, so you will need to change the `name` field to something unique.
We recommend that the filename matches the `name` field, e.g. `myassignment.alz_policy_assignment.json`.
{{< /hint >}}

We recommend configuring parameters in the [policy_assignments_to_modify]({{< relref "modifyingPolicyAssignments" >}}) input variable, rather than in the asset file itself.

###  Assigning a custom policy definition or policy set definition

In this scenario you will need to create `<mydefinition>.alz_policy_definition.json` / `<mysetdefinition>.alz_policy_set_definition.json` (or YAML) files in your custom library.

Then you create a `<myassignment>.alz_policy_assignment.json` (or YAML) file in your custom library, as per the above scenario.

{{< hint type=note >}}
The resource id of the eventually deployed asset will not be known at the time of the file creation.
Luckily, alzlib and the ALZ provider will index assets by their name only.
When creating references between assets, you must specify a sane resource id, however the only segment that is used is the final one: e.g. in the example reference `/providers/Microsoft.Management/managementGroups/placeholder/Microsoft.Authorization/policyDefinitions/mydefinition` - the `mydefinition` segment is used to lookup the asset.
{{< /hint >}}

## Step two - Create an override archetype

Once you have created your new assets, you will need to create an [override archetype](https://azure.github.io/Azure-Landing-Zones-Library/assets/archetype-overrides/) in your custom library.
This can be in either YAML or JSON format.

An override archetype is a special type of archetype that is used to store a delta of changes to an existing archetype.
It creates a new archetype that is a combination of the original archetype and the override archetype.

Here is an example override archetype in YAML format:

```yaml
name: "landing_zones_override"
base_archetype: "landing_zones"
policy_assignments_to_add: []
policy_assignments_to_remove:
  - "Deny-IP-forwarding"
policy_definitions_to_add: []
policy_definitions_to_remove: []
policy_set_definitions_to_add: []
policy_set_definitions_to_remove: []
role_definitions_to_add: []
role_definitions_to_remove: []
```

It is possible to add or remove policy assignments, policy definitions, policy set definitions and role definitions.

## Step three - Assign the override archetype to a management group

Finally, you will need to assign the override archetype to the management group(s) you want to modify.
For this you will need to create an [architecture definition](https://azure.github.io/Azure-Landing-Zones-Library/assets/architectures/) in your custom library.

```yaml
name: my architecture
management_groups:
  # ... other management groups
  - id: landingzones
    display_name: Landing Zones
    archetypes:
      - landing_zones_override
    parent_id: my-mg
    exists: false
```

Once you have done this, you can deploy the ALZ module, specifying the `architecture_name` variable to point to your custom architecture definition.
