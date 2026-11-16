# Netbox Terraform module

This module manages the mac address for virtual machines and devices managed with Netbox.

It manages the following sections:

- [ ] virtual machine/device - interface - Mac Address

## Usage

```hcl
module "netbox-vm" {
  source = "github.com/CubelaPetar/tf-mod-netbox//netbox-macaddr"

  for_each = var.macaddr_config

  devices = each.value.devices
  vms     = each.value.vms
}
```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md
