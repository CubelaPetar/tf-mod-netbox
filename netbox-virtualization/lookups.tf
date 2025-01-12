# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

# ######## LOOKUPS ############

# lookup device roles by name
data "netbox_device_role" "roles_lookups" {
  for_each = toset([
    for vm in var.vms : vm.role if vm.role != null
  ])

  name = each.value
}

# lookup platforms by name
data "netbox_platform" "platforms_lookups" {
  for_each = toset([
    for vm in var.vms : vm.platform if vm.platform != null
  ])

  name = each.value
}

# lookup devices by name
data "netbox_devices" "devices_lookups" {
  for_each = toset([
    for vm in var.vms : vm.device if vm.device != null
  ])

  filter {
    name  = "name"
    value = each.value
  }
}

# lookup clusters by name
data "netbox_cluster" "clusters_lookups" {
  for_each = toset([
    for vm in var.vms : vm.cluster if vm.cluster != null
  ])

  name = each.value
}

locals {
  tagged_vlans = flatten([
    for vm in var.vms : [
      for iface in vm.networking : iface.tagged_vlans if iface.tagged_vlans != null
    ]
  ])

  untagged_vlans = flatten([
    for vm in var.vms : [
      for iface in vm.networking : iface.untagged_vlan if iface.untagged_vlan != null
    ]
  ])

  all_vlans = [for v in distinct(concat(local.tagged_vlans, local.untagged_vlans)) : tostring(v)]
}

# lookup vlans by vid
data "netbox_vlan" "vlans_lookups" {
  for_each = toset(local.all_vlans)

  vid = tonumber(each.value)
}

locals {
  roles_id_map = {
    for role_name, role_data in data.netbox_device_role.roles_lookups :
    role_name => role_data.id
  }

  platform_id_map = {
    for platform_name, platform_data in data.netbox_platform.platforms_lookups :
    platform_name => platform_data.id
  }

  device_id_map = {
    for device_name, device_data in data.netbox_devices.devices_lookups :
    device_name => device_data.devices[0].device_id
  }

  vlan_id_map = {
    for vlan_name, vlan_data in data.netbox_vlan.vlans_lookups :
    vlan_name => vlan_data.id
  }

  cluster_id_map = {
    for cluster_name, cluster_data in data.netbox_cluster.clusters_lookups :
    cluster_name => cluster_data.id
  }
}

# ####### END LOOKUPS ###########
