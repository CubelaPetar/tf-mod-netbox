# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

# ######## LOOKUPS ############
# Look up racks by name
data "netbox_racks" "racks_lookups" {
  for_each = toset([
    for vgroup in var.vlan_groups : vgroup.scope if vgroup.scope_type == "dcim.rack" && vgroup.scope != null
  ])

  filter {
    name  = "name"
    value = each.value
  }
  limit = 1
}

data "netbox_device_interfaces" "dev_interfaces_lookups" {
  for_each = toset([
    for ip in var.ip_addresses : ip.dev_interface if ip.dev_interface != null
  ])

  filter {
    name  = "name"
    value = each.value
  }
}

data "netbox_interfaces" "vm_interfaces_lookups" {
  for_each = toset([
    for ip in var.ip_addresses : ip.virtual_machine_interface if ip.virtual_machine_interface != null
  ])

  filter {
    name  = "name"
    value = each.value
  }
  limit = 1
}

locals {
  rack_id_map = {
    for rack_name, rack_data in data.netbox_racks.racks_lookups :
    rack_name => rack_data.racks[0].id
  }

  dev_interfaces_id_map = {
    for interface_id, interface_data in data.netbox_device_interfaces.dev_interfaces_lookups :
    interface_data.interfaces[0].name => interface_data.interfaces[0].id
  }

  vm_interface_id_map = {
    for vm_interface_id, vm_interface_data in data.netbox_interfaces.vm_interfaces_lookups :
    vm_interface_id => vm_interface_data.interfaces[0].id
  }
}
# ######## END LOOKUPS ############
