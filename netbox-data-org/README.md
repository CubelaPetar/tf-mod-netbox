# Netbox Terraform module

This module handles data retrieval from Netbox.

It is used to fetch commonly needed data in order to keep the resource modules clean of repeating lookups.

It fetches the following categories from the organization section:

- [x] sites
- [x] site groups
- [x] tenant
- [x] location
- [x] regions

## Usage

```terraform
module "netbox-org-data" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-data-org"

  depends_on = [module.netbox-organization]

  for_each = var.organizations

  sites       = each.value.data.sites
  site_groups = each.value.data.sites_groups
  tenants     = each.value.data.tenants
  locations   = each.value.data.locations
  regions     = each.value.data.regions
}

Then use the data in another module call, like:

module "netbox-ipam" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-ipam"

  depends_on = [module.netbox-org, module.netbox-org-data, module.netbox-devices]

  for_each = var.organizations

  ...

  site_id_map       = module.netbox-org-data[each.key].sites_map
  location_id_map   = module.netbox-org-data[each.key].locations_map
  tenant_id_map     = module.netbox-org-data[each.key].tenants_map
  region_id_map     = module.netbox-org-data[each.key].regions_map
  site_group_id_map = module.netbox-org-data[each.key].site_groups_map
}
```

## LICENSE

Check the LICENSE.md
