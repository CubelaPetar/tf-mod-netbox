# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 5.0.0"
    }
  }
}

resource "netbox_device_primary_ip" "dev_primary_ipv4" {
  for_each = var.devices

  device_id     = local.device_id_map[each.key]
  ip_address_id = local.ip_id_map[each.value]
}

resource "netbox_primary_ip" "vm_primary_ipv4" {
  for_each = var.vms

  virtual_machine_id = local.vm_id_map[each.key]
  ip_address_id      = local.ip_id_map[each.value]
}
