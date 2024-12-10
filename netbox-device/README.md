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
  source = "github.com/rendler-denis/tf-netbox-mod-device"

  # useful if you manage the entire organization through needs
  # modules. otherwise you have to create in advance organization and racks
  depends_on = [ module.netbox-org, module.netbox-racks ]

  for_each = var.organizations

  device_roles  = each.value.device_config.device_roles
  manufacturers = each.value.device_config.manufacturers
  device_types  = each.value.device_config.device_types
  platforms     = each.value.device_config.platforms
  devices       = each.value.device_config.devices
}
```

For a data example check the example folder.

The module will automatically lookup the organization and racks information by name.

## LICENSE

Check the LICENSE.md
