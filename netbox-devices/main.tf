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

# ######## LOOKUPS ############
# Look up racks by name
data "netbox_racks" "racks_lookups" {
  for_each = toset([
    for device in var.devices : device.rack if device.rack != null
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
}
# ######## END LOOKUPS ############

# ######## CONFIGURE DEVICE ############
resource "netbox_device_role" "dev_roles" {
  for_each = var.device_roles

  color_hex   = each.value.color_hex
  name        = each.value.name != null ? each.value.name : each.key
  slug        = each.value.slug
  description = try(each.value.description, null)
  vm_role     = try(each.value.vm_role, null)

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "netbox_manufacturer" "dev_manufacturers" {
  for_each = var.manufacturers

  name = each.value.name != null ? each.value.name : each.key
  slug = each.value.slug
}

resource "netbox_device_type" "dev_types" {
  for_each = var.device_types

  manufacturer_id = netbox_manufacturer.dev_manufacturers[each.value.manufacturer].id
  model           = each.value.model
  slug            = each.value.slug
  u_height        = each.value.height

  is_full_depth = try(each.value.is_full_depth, null)
  part_number   = try(each.value.part_number, null)

  lifecycle {
    ignore_changes = [ tags ]
  }
}

resource "netbox_platform" "dev_platforms" {
  for_each = var.platforms

  name = each.value.name

  slug            = each.value.slug
  manufacturer_id = try(netbox_manufacturer.dev_manufacturers[each.value.manufacturer].id, null)
}

resource "netbox_device" "device-info" {
  for_each = var.devices

  name           = each.value.name != null ? each.value.name : each.key
  device_type_id = netbox_device_type.dev_types[each.value.type].id
  role_id        = netbox_device_role.dev_roles[each.value.role].id
  site_id        = var.site_id_map[each.value.site]

  tenant_id          = try(var.tenant_id_map[each.value.tenant], null)
  location_id        = try(var.location_id_map[each.value.location], null)
  asset_tag          = try(each.value.asset_tag, null)
  cluster_id         = try(each.value.cluster, null)
  comments           = try(each.value.comments, each.key)
  custom_fields      = try(each.value.custom_fields, null)
  config_template_id = try(each.value.config_template, null)
  description        = try(each.value.description, null)
  local_context_data = jsonencode(try(each.value.local_context_data, {}))
  platform_id        = try(netbox_platform.dev_platforms[each.value.platform].id, null)
  rack_id            = try(local.rack_id_map[each.value.rack], null)
  rack_face          = try(each.value.rack_face, null)
  rack_position      = try(each.value.rack_position, null)
  serial             = try(each.value.serial, null)
  status             = try(each.value.status, null)

  lifecycle {
    ignore_changes = [ tags, comments ]
  }
}

resource "netbox_device_interface" "dev_interfaces" {
   for_each = merge([
    for device_key, device in var.devices : {
      for iface in device.interfaces : "${device.name}_${iface.name}" => merge(iface, { device = device_key, device_name = device.name })
    } if device.interfaces != null
  ]...)

  name      = "${each.value.name} (${each.value.device_name})"
  device_id = netbox_device.device-info[each.value.device].id
  type      = each.value.type

  description                = try(each.value.description, null)
  enabled                    = try(each.value.enabled, null)
  label                      = try(each.value.label, null)
  mac_address                = try(each.value.mac_address, null)
  mgmtonly                   = try(each.value.mgmtonly, false)
  mode                       = try(each.value.mode, "access")
  mtu                        = try(each.value.mtu, 1500)
  speed                      = try(each.value.speed, null)
  tagged_vlans               = try(each.value.tagged_vlans, null)
  untagged_vlan              = try(each.value.untagged_vlan, null)

  lifecycle {
    ignore_changes = [tags, parent_device_interface_id, lag_device_interface_id]
  }

}

# ######## END CONFIGURE DEVICE ############
