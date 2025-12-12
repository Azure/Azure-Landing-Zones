---
title: Advanced scenarios
weight: 110
---

## Scenario 1 - Secure island for bootstrap resources

Depending on your security needs, you may wish to store the Azure resources deployed by the bootstrap in separate subscription and optionally a separate management group hierarchy to the Azure Landing Zone. This could be the case when you need to separate the concerns of deploying and maintaining the Azure Landing Zone from the day to day access of the Azure Landing Zone.

The resources deployed by the bootstrap vary depending on the options you choose, but they may include the following:

- Storage account for state file
- User assigned managed identities
- [Optional] Self hosted agents
- [Optional] Networking, DNS and Private End Point for storage account

In order to use the secure island approach, you can follow these steps:

### Option 1 - Separate subscription under separate management group hierarchy

1. Create a new management group under `Tenant Root Group`.
1. Apply your desired policies and permissions to the new management group.
1. Create a new subscription for the bootstrap resources and place it in the new management group. Take note of the subscription id.
1. Grant owner rights to the account you are using to deploy the accelerator on the new subscription.
1. Run the bootstrap as normal, following the instructions in the [Quick Start]({{< relref "1_prerequisites" >}}) guide.
1. When you get to step for updating the input config file variables, enter the subscription id of the new subscription you created into the `bootstrap_subscription_id` field.
1. Continue with the rest of the steps in the [Quick Start]({{< relref "1_prerequisites" >}}) guide.

This will result in the bootstrap resources being deployed in the new subscription and management group hierarchy, while the Azure Landing Zone is deployed into the defined management group hierarchy.

### Option 2 - Separate subscription under Azure landing zone management group hierarchy

1. Create a new subscription for the bootstrap resources. Take note of the subscription id.
2. Grant owner rights to the account you are using to deploy the accelerator on the new subscription.
3. Use the `platform_landing_zone` starter module to deploy the Azure Landing Zone.
4. Update the `tfvars` file to include subscription placement for the new subscription using the `management_group_settings.subscription_placement` setting. For example:

    ```terraform
    management_group_settings = {
      subscription_placement = {
        identity = {
          subscription_id       = "$${subscription_id_identity}"
          management_group_name = "identity"
        }
        connectivity = {
          subscription_id       = "$${subscription_id_connectivity}"
          management_group_name = "connectivity"
        }
        management = {
          subscription_id       = "$${subscription_id_management}"
          management_group_name = "management"
        }
        security = {
          subscription_id       = "$${subscription_id_security}"
          management_group_name = "security"
        }
        bootstrap = {
          subscription_id       = "<bootstrap-subscription-id>" # Add your bootstrap subscription id here
          management_group_name = "management"
        }
      }
    }
    ```

5. Run the bootstrap as normal, following the instructions in the [Quick Start]({{< relref "1_prerequisites" >}}) guide.
6. When you get to step for updating the bootstrap configuration file variables, enter the subscription id of the new subscription you created into the `bootstrap_subscription_id` field.
7. Continue with the rest of the steps in the [Quick Start]({{< relref "1_prerequisites" >}}) guide.

This will result in the bootstrap resources being deployed in the new subscription.
When you then deploy the Azure Landing Zone your subscription will be moved under the `management` management group.
