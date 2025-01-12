# Netbox Terraform module

This module handles IPAM management in Netbox.

It is used to manage the entire IPAM section.

- [x] RIRs
- [x] aggregates
- [x] VLAN roles
- [x] VRFS
- [x] VLAN groups
- [x] VLANs
- [x] Prefixes
- [x] IP ranges
- [x] IPs

## Usage

```terraform
module "netbox-ipam" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-ipam"

  depends_on = [module.netbox-org, module.netbox-org-data, module.netbox-devices]

  rirs         = var.organizations.ipam_config.rirs
  aggregates   = var.organizations.ipam_config.aggregates
  roles        = var.organizations.ipam_config.roles
  vrfs         = var.organizations.ipam_config.vrfs
  vlan_groups  = var.organizations.ipam_config.vlan_groups
  vlans        = var.organizations.ipam_config.vlans
  prefixes     = var.organizations.ipam_config.prefixes
  ip_ranges    = var.organizations.ipam_config.ip_ranges
  ip_addresses = var.organizations.ipam_config.ip_addresses

  site_id_map       = module.netbox-org-data.sites_map
  location_id_map   = module.netbox-org-data.locations_map
  tenant_id_map     = module.netbox-org-data.tenants_map
  region_id_map     = module.netbox-org-data.regions_map
  site_group_id_map = module.netbox-org-data.site_groups_map
}
```

## LICENSE

Check the LICENSE.md
