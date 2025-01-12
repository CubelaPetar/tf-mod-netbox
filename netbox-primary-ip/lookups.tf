# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

# ######## LOOKUPS ############

# lookup devices by name
data "netbox_devices" "devices_lookups" {
  for_each = var.devices

  filter {
    name  = "name"
    value = each.key
  }
}

# lookup vm by name
data "netbox_virtual_machines" "vms" {
  for_each = var.vms

  filter {
    name  = "name"
    value = each.key
  }
}

locals {
  all_ips = distinct(flatten([
    [for dev_name, dev in var.devices : dev],
    [for vm_name, vm in var.vms : vm]
  ]))
}

# lookup vm ip by address
data "netbox_ip_addresses" "ip_lookups" {
  for_each = { for ip in local.all_ips : ip => {} }

  filter {
    name  = "ip_address"
    value = each.key
  }

  limit = 1
}

locals {
  device_id_map = {
    for device_name, device_data in data.netbox_devices.devices_lookups :
    device_name => device_data.devices[0].device_id
  }

  vm_id_map = {
    for vm_name, vm_data in data.netbox_virtual_machines.vms :
    vm_data.vms[0].name => vm_data.vms[0].vm_id
  }

  ip_id_map = {
    for ip_addr, ip_data in data.netbox_ip_addresses.ip_lookups :
    ip_data.ip_addresses[0].ip_address => ip_data.ip_addresses[0].id
  }
}

# ####### END LOOKUPS ###########
