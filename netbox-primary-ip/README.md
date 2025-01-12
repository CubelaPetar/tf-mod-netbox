# Netbox Terraform module

This module manages the primary IP for virtual machines and devices managed with Netbox.

It manages the following sections:

- [x] virtual machine - Primary IP

## Usage

```hcl
module "netbox-vm" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-primary-ip"

  for_each = var.primary_ip_config

  devices = each.value.devices
  vms     = each.value.vms
}
```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md
