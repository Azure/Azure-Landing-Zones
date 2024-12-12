hub_and_spoke_vnet_virtual_networks = {
  primary = {
    # Example hub network settings for this region
    hub_virtual_network = {
      name                            = "vnet-hub-$${starter_location_01}"
      resource_group_name             = "$${connectivity_hub_primary_resource_group_name}"
      resource_group_creation_enabled = false
      location                        = "$${starter_location_01}"
      address_space                   = ["$${primary_hub_virtual_network_address_space}"]
      routing_address_space           = ["$${primary_hub_address_space}"]
      route_table_name_firewall       = "rt-hub-fw-$${starter_location_01}"
      route_table_name_user_subnets   = "rt-hub-std-$${starter_location_01}"
      mesh_peering                    = true
      ddos_protection_plan_id         = "$${management_resource_group_id}/providers/Microsoft.Network/ddosProtectionPlans/$${ddos_protection_plan_name}"
      subnets                         = {}
      # Example Azure Firewall settings for this region (omit this section if not using Azure Firewall)
      firewall = {
        subnet_address_prefix = "$${primary_firewall_subnet_address_prefix}"
        name                  = "fw-hub-$${starter_location_01}"
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = "$${starter_location_01_availability_zones}"
        default_ip_configuration = {
          public_ip_config = {
            name  = "pip-fw-hub-$${starter_location_01}"
            zones = "$${starter_location_01_availability_zones}"
          }
        }
        # Example firewall policy settings for this region
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
        }
      }
    }
    # Example Virtual Network Gateway settings for this region (omit this section if not using Virtual Network Gateway)
    virtual_network_gateways = {
      subnet_address_prefix = "$${primary_gateway_subnet_address_prefix}"
      # Example ExpressRoute settings for this region (omit this section if not using ExpressRoute)
      express_route = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-expressroute-$${starter_location_01}"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_express_route}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-expressroute-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-expressroute-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
      # Example VPN Gateway settings for this region (omit this section if not using VPN Gateway)
      vpn = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-vpn-$${starter_location_01}"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_vpn}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-vpn-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-vpn-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
    }
    # Example Private DNS Zone settings for this region (omit this section if not using Private DNS Zones)
    private_dns_zones = {
      resource_group_name            = "$${dns_resource_group_name}"
      is_primary                     = true
      auto_registration_zone_enabled = true
      auto_registration_zone_name    = "$${starter_location_01}.azure.local"
      subnet_address_prefix          = "$${primary_private_dns_resolver_subnet_address_prefix}"
      private_dns_resolver = {
        name = "pdr-hub-dns-$${starter_location_01}"
      }
    }
    # Example Bastion Host settings for this region (omit this section if not using Bastion Host)
    bastion = {
      subnet_address_prefix = "$${primary_bastion_subnet_address_prefix}"
      bastion_host = {
        name = "bastion-hub-$${starter_location_01}"
      }
      bastion_public_ip = {
        name  = "pip-bastion-hub-$${starter_location_01}"
        zones = "$${starter_location_01_availability_zones}"
      }
    }
  }
}
