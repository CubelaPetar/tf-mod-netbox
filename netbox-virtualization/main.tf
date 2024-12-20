# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-racks
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_providers {
    netbox = {
      source = "e-breuninger/netbox"
    }
  }
}

# ######## LOOKUPS ############

# lookup roles by name
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
    device_name => device_data.devices[0].id
  }
}

# ####### END LOOKUPS ###########

# ######## CONFIGURE VIRTUALIZATION ############

resource "netbox_cluster_type" "cluster_types" {
  for_each = var.cluster_types

  name = each.value.name
  slug = each.value.slug
}

resource "netbox_cluster_group" "cluster_groups" {
  for_each = var.cluster_groups

  name        = each.value.name
  description = each.value.description
  slug        = each.value.slug
}

resource "netbox_cluster" "clusters" {
  for_each = var.clusters

  name            = each.value.name
  cluster_type_id = netbox_cluster_type.cluster_types[each.value.cluster_type].id

  cluster_group_id = try(netbox_cluster_group.cluster_groups[each.value.cluster_group].id, null)
  site_id          = try(var.site_id_map[each.value.site], null)
  tenant_id        = try(var.tenant_id_map[each.value.tenant], null)
  comments         = try(each.value.comments, null)
  description      = try(each.value.description, null)
  tags             = try(each.value.tags, null)
}

resource "netbox_virtual_machine" "vms" {
  for_each = var.vms

  name = each.value.name

  vcpus       = try(each.value.vcpus, null)
  memory_mb   = try(each.value.memory_mb, null)
  platform_id = try(local.platform_id_map[each.value.platform], null)
  device_id   = try(local.device_id_map[each.value.device], null)

  cluster_id         = try(netbox_cluster.clusters[each.value.cluster].id, null)
  site_id            = try(var.site_id_map[each.value.site], null)
  tenant_id          = try(var.tenant_id_map[each.value.tenant], null)
  role_id            = try(local.roles_id_map[each.value.role], null)
  status             = try(each.value.status, "planned")
  custom_fields      = try(each.value.custom_fields, null)
  description        = try(each.value.description, null)
  comments           = try(each.value.comments, null)
  local_context_data = try(jsonencode(each.value.local_context_data), null)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "netbox_virtual_disk" "vm_disks" {
  for_each = { for vm in var.vms : vm.name => vm.disks }

  virtual_machine_id = netbox_virtual_machine.vms[each.key].id
  name               = each.value.name
  size_gb            = each.value.size

  custom_fields = try(each.value.custom_fields, null)
  description   = try(each.value.description, null)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "netbox_interface" "myvm_eth1" {
  for_each = { for vm in var.vms : vm.name => vm.iface }

  virtual_machine_id = netbox_virtual_machine.vms[each.key].id
  name               = each.value.name

  description   = try(each.value.description, null)
  enabled       = try(each.value.enabled, null)
  mac_address   = try(each.value.mac_address, null)
  mode          = try(each.value.mode, null)
  mtu           = try(each.value.mtu, null)
  tagged_vlans  = try(each.value.tagged_vlans, null)
  type          = try(each.value.type, null)
  untagged_vlan = try(each.value.untagged_vlan, null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# ######## END CONFIGURE VIRTUALIZATION ############
