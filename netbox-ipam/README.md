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

  for_each = var.organizations

  rirs         = each.value.ipam_config.rirs
  aggregates   = each.value.ipam_config.aggregates
  roles        = each.value.ipam_config.roles
  vrfs         = each.value.ipam_config.vrfs
  vlan_groups  = each.value.ipam_config.vlan_groups
  vlans        = each.value.ipam_config.vlans
  prefixes     = each.value.ipam_config.prefixes
  ip_ranges    = each.value.ipam_config.ip_ranges
  ip_addresses = each.value.ipam_config.ip_addresses

  site_id_map       = module.netbox-org-data[each.key].sites_map
  location_id_map   = module.netbox-org-data[each.key].locations_map
  tenant_id_map     = module.netbox-org-data[each.key].tenants_map
  region_id_map     = module.netbox-org-data[each.key].regions_map
  site_group_id_map = module.netbox-org-data[each.key].site_groups_map
}
```

## LICENSE

Check the LICENSE.md
