# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-device
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_providers {
    netbox = {
      source = "e-breuninger/netbox"
    }
  }
}

# ######## LOOKUPS ############
data "netbox_site" "site_lookups" {
  for_each = toset([
    for device in var.devices : device.site
  ])
  name = each.value
}

# Look up tenants by name
data "netbox_tenant" "tenant_lookups" {
  for_each = toset([
    for device in var.devices : device.tenant if device.tenant != null
  ])
  name = each.value
}

# Look up locations by name
data "netbox_location" "location_lookups" {
  for_each = toset([
    for device in var.devices : device.location if device.location != null
  ])
  # slug = each.value
  name = each.value
}

# Look up locations by name
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
  # Create lookup maps
  site_id_map = {
    for site_name, site_data in data.netbox_site.site_lookups :
    site_name => site_data.id
  }

  tenant_id_map = {
    for tenant_name, tenant_data in data.netbox_tenant.tenant_lookups :
    tenant_name => tenant_data.id # Direct access to id, no tenants[0]
  }

  location_id_map = {
    for location_name, location_data in data.netbox_location.location_lookups :
    location_name => location_data.id
  }

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
  name        = each.value.name
  slug        = each.value.slug
  description = try(each.value.description, null)
  tags        = try(each.value.tags, null)
  vm_role     = try(each.value.vm_role, null)
}

resource "netbox_manufacturer" "dev_manufacturers" {
  for_each = var.manufacturers

  name = each.value.name
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
  tags          = try(each.value.tags, null)
}

resource "netbox_platform" "dev_platforms" {
  for_each = var.platforms

  name = each.value.name

  slug            = each.value.slug
  manufacturer_id = netbox_manufacturer.dev_manufacturers[each.value.manufacturer].id
}

resource "netbox_device" "device-info" {
  for_each = var.devices

  name           = each.value.name
  device_type_id = netbox_device_type.dev_types[each.value.type].id
  role_id        = netbox_device_role.dev_roles[each.value.role].id
  site_id        = local.site_id_map[each.value.site]

  tenant_id          = try(local.tenant_id_map[each.value.tenant], null)
  location_id        = try(local.location_id_map[each.value.location], null)
  asset_tag          = try(each.value.asset_tag, null)
  cluster_id         = try(each.value.cluster, null)
  comments           = try(each.value.comments, null)
  custom_fields      = try(each.value.custom_fields, null)
  config_template_id = try(each.value.config_template, null)
  description        = try(each.value.description, null)
  local_context_data = jsonencode(try(each.value.local_context_data, {}))
  platform_id        = netbox_platform.dev_platforms[each.value.platform].id
  rack_id            = try(local.rack_id_map[each.value.rack], null)
  rack_face          = try(each.value.rack_face, null)
  rack_position      = try(each.value.rack_position, null)
  serial             = try(each.value.serial, null)
  status             = try(each.value.status, null)
}

# ######## END CONFIGURE DEVICE ############
