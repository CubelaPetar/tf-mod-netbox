# Netbox Terraform module

This module manages the racks information in Netbox.

It manages the following sections:

- [x] Rack roles
- [x] Racks configuration
- [x] Rack reservations

## Usage

```terraform
module "netbox-racks" {
  source = "github.com/rendler-denis/tf-netbox-mod-racks"

  depends_on = [ module.netbox-org, module.netbox-data-org ]

  rack_roles        = var.organizations.rack_config.rack_roles
  racks             = var.organizations.rack_config.racks
  rack_reservations = var.organizations.rack_config.rack_reservations

  site_id_map       = module.netbox-org-data.sites_map
  location_id_map   = module.netbox-org-data.locations_map
  tenant_id_map     = module.netbox-org-data.tenants_map
}
```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md
