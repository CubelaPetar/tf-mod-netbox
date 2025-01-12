# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_providers {
    netbox = {
      source = "e-breuninger/netbox"
    }
  }
}

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

  lifecycle {
    ignore_changes = [tags, comments]
  }
}

resource "netbox_virtual_machine" "vms" {
  for_each = var.vms

  name = each.value.name

  vcpus       = try(each.value.vcpus, null)
  memory_mb   = try(each.value.memory_mb, null)
  platform_id = try(local.platform_id_map[each.value.platform], null)
  device_id   = try(local.device_id_map[each.value.device], null)

  cluster_id         = try(netbox_cluster.clusters[each.value.cluster].id, try(local.cluster_id_map[each.value.cluster], null))
  site_id            = try(var.site_id_map[each.value.site], null)
  tenant_id          = try(var.tenant_id_map[each.value.tenant], null)
  role_id            = try(local.roles_id_map[each.value.role], null)
  status             = try(each.value.status, "planned")
  custom_fields      = try(each.value.custom_fields, null)
  description        = try(each.value.description, null)
  comments           = try(each.value.comments, null)
  local_context_data = try(jsonencode(each.value.local_context_data), null)

  lifecycle {
    ignore_changes = [tags, comments]
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

resource "netbox_interface" "vm_eth" {
  for_each = {
    for interface in flatten([
      for vm_name, vm in var.vms : [
        for net in vm.networking : {
          vm_name   = vm_name
          interface = net
        }
      ]
    ]) : "${interface.vm_name}_${interface.interface.name}" => interface
  }

  name               = each.value.interface.name
  virtual_machine_id = netbox_virtual_machine.vms[each.value.vm_name].id

  description   = try(each.value.interface.description, null)
  enabled       = try(each.value.interface.enabled, true)
  mac_address   = try(each.value.interface.mac_address, null)
  mode          = try(each.value.interface.mode, "access")
  mtu           = try(each.value.interface.mtu, "1500")
  untagged_vlan = each.value.interface.untagged_vlan != null ? local.vlan_id_map[each.value.interface.untagged_vlan] : null
  tagged_vlans  = each.value.interface.tagged_vlans != null ? [for vlan in each.value.interface.tagged_vlans : local.vlan_id_map[vlan]] : []

  lifecycle {
    ignore_changes = [tags, description, mtu]
  }
}

# ######## END CONFIGURE VIRTUALIZATION ############
