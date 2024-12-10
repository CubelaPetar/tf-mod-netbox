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

  # useful if you manage the entire organization through these
  # modules. otherwise you have to configure in advance the organization info
  depends_on = [ module.netbox-org ]

  for_each = var.organizations

  rack_roles        = each.value.rack_config.rack_roles
  racks             = each.value.rack_config.racks
  rack_reservations = each.value.rack_config.rack_reservations
}
```

For a data example check the example folder.

The module will automatically lookup the organization information by name.

## LICENSE

Check the LICENSE.md
