---
title: 15 - Implement Sovereign Landing Zone (SLZ) controls
geekdocCollapseSection: true
weight: 15
---

The Sovereign Landing Zone (SLZ) is a compliance-focused implementation designed for regulated industries that demand high data sovereignty. It incorporates specific controls and configurations to meet stringent regulatory requirements. The SLZ policies can be reviewd here:

- [Sovereignty Baseline - Global Policies](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/c1cbff38-87c0-4b9f-9f70-035c7a3b5523.html)
  - Applied at th root management group level
- [Sovereignty Baseline - Confidential Policies](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/03de05a4-c324-4ccd-882f-a814ea8ab9ea.html)
  - Applied at the Confidential Corp and Confidential Online management group levels

The steps to follow are:

1. Locate the `lib` folder in your `config` directory. This folder was created in the initial steps of phase 2.

1. Open the `architecture_definitions\alz_custom.alz_architecture_definition.yaml` file. Uncomment the two management groups for `Confidential Corp` and `Confidential Online` by removing the `#` characters at the start of the lines. Save the file.

2. Open the `archetype_definitions\root_custom.alz_archetype_override.yaml` file. Uncomment the two policy assignment blocks for the SLZ policies by removing the `#` characters at the start of the lines. Save the file.

    The file should look like this:

    ```yaml
    base_archetype: root
    name: root_custom
    policy_assignments_to_add: [
    # To enable Sovereign Landing Zone, uncomment the following line:
    "Enforce-Sovereign-Global"
    ]
    policy_assignments_to_remove: []
    policy_definitions_to_add: []
    policy_definitions_to_remove: []
    policy_set_definitions_to_add: []
    policy_set_definitions_to_remove: []
    role_definitions_to_add: []
    role_definitions_to_remove: []
    ```
