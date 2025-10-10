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

1. Update the `architecture_name` setting to `"slz_custom"` in the `management_group_settings` block.

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `management_group_settings` | `architecture_name` | Update the value from `"alz_custom"` to `"slz_custom"` | 1 | The architecture file for ALZ will already have been copied to your lib folder structure |
