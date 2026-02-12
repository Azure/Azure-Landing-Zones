---
title: 4 - Turn off Bastion host
geekdocCollapseSection: true
weight: 4
---

You can choose to not deploy a Bastion Host. In order to do that, you need to update the Bastion Host configuration.

The steps to follow are:

1. Update the following settings by searching for the keys and updating the value

    | Setting Type | Parent block(s) | Key | Action | Count | Notes |
    | - | - | - | - | - | - |
    | line | `custom_replacements` > `names` | `<region>_bastion_enabled` | Update setting to `false` | 1+ | `<region>` is the relevant region (e.g. `primary`) |

    {{< hint type=warning >}}
You should not remove the Bastion Host names from the `custom_replacements` section as it will result in a templating error. Advanced Terraform users are welcome to tidy up the config and remove the names and related templates if there is no future plan to use a Bastion Host.
    {{< /hint >}}
