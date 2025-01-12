# Netbox Terraform module

This module manages devices, platforms and manufacturers in Netbox.

It manages the following categories:

- [x] Device roles
- [x] Manufacturers
- [x] Device types
- [x] Platforms
- [x] Devices

## Usage

```terraform
module "netbox-devices" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-devices"

  # used if you manage all the organization info with this module
  depends_on = [ module.netbox-org, module.netbox-racks, module.netbox-data-org ]

  device_roles  = var.organizations.device_config.device_roles
  manufacturers = var.organizations.device_config.manufacturers
  device_types  = var.organizations.device_config.device_types
  platforms     = var.organizations.device_config.platforms
  devices       = var.organizations.device_config.devices

  site_id_map       = module.netbox-org-data.sites_map
  tenant_id_map     = module.netbox-org-data.tenants_map
}
```

For a data example check the example folder.

The module will automatically lookup the organization and racks information by name.

## LICENSE

Check the LICENSE.md
