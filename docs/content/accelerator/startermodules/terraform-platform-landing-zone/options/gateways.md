---
title: 6 - Turn off Virtual Network Gateways
geekdocCollapseSection: true
weight: 6
---

You can choose to not deploy any Virtual Network Gateways. In order to do that, you need to remove the Virtual Network Gateway configuration. You can either comment out or remove the configuration entirely.

The steps to follow are:

1.  To keep the code tidy remove the follow settings from `custom_replacements.names`:
  1. `<region>_virtual_network_gateway_express_route_name` where `<region>` is for each region
  1. `<region>_virtual_network_gateway_express_route_public_ip_name` where `<region>` is for each region
  1. `<region>_virtual_network_gateway_vpn_name` where `<region>` is for each region
  1. `<region>_virtual_network_gateway_vpn_public_ip_name` where `<region>` is for each region
  1. `<region>_gateway_subnet_address_prefix` where `<region>` is for each region
1. Remove the whole `virtual_network_gateways` section from each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

You can also just turn off the specific Virtual Network Gateway types you don't want to deploy.

For ExpressRoute Virtual Network Gateways:

1. Remove the whole `express_route` section from the `virtual_network_gateways` section in each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region

For VPN Virtual Network Gateways:

1. Remove the whole `vpn` section from the `virtual_network_gateways` section in each `hub_and_spoke_vnet_virtual_networks` or `virtual_wan_virtual_hubs` region
