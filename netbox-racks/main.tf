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
data "netbox_site" "site_lookups" {
  for_each = toset([
    for rack in var.racks : rack.site
  ])
  name = each.value
}

# Look up tenants by name
data "netbox_tenant" "tenant_lookups" {
  for_each = toset([
    for rack in var.racks : rack.tenant if rack.tenant != null
  ])
  name= each.value
}

# Look up locations by name
data "netbox_location" "location_lookups" {
  for_each = toset([
    for rack in var.racks : rack.location if rack.location != null
  ])
  # slug = each.value
  name = each.value
}

locals {
  # Create lookup maps
  site_id_map = {
    for site_name, site_data in data.netbox_site.site_lookups :
    site_name => site_data.id
  }

  tenant_id_map = {
    for tenant_name, tenant_data in data.netbox_tenant.tenant_lookups :
    tenant_name => tenant_data.id  # Direct access to id, no tenants[0]
  }

  location_id_map = {
    for location_name, location_data in data.netbox_location.location_lookups :
    location_name => location_data.id
  }
}

# ######## END LOOKUPS ############


# ######## CONFIGURE RACKS ############

# Create Rack Roles
resource "netbox_rack_role" "rack_roles" {
  for_each = var.rack_roles

  name        = each.value.name
  slug        = each.value.slug
  color_hex   = each.value.color
  description = each.value.description
}

resource "netbox_rack" "racks" {
  for_each = var.racks

  name           = each.value.name
  site_id        = local.site_id_map[each.value.site]
  status         = each.value.status
  width          = each.value.width
  u_height       = each.value.u_height
  asset_tag      = try(each.value.asset_tag, null)
  comments       = try(each.value.comments, null)
  custom_fields  = try(each.value.custom_fields, null)
  desc_units     = try(each.value.desc_units, false)
  description    = try(each.value.description, null)
  facility_id    = try(each.value.facility, null)
  location_id    = try(each.value.location, null) != null ? local.location_id_map[each.value.location] : null
  max_weight     = try(each.value.max_weight, null)
  mounting_depth = try(each.value.mounting_depth, null)
  outer_depth    = try(each.value.outer_depth, null)
  outer_unit     = try(each.value.outer_unit, "mm")
  outer_width    = try(each.value.outer_width, null)
  role_id        = try(each.value.role, null) != null ? netbox_rack_role.rack_roles[each.value.role].id : null
  serial         = try(each.value.serial, null)
  tags           = try(each.value.tags, null)
  tenant_id      = try(each.value.tenant, null) != null ? local.tenant_id_map[each.value.tenant] : null
  type           = try(each.value.type, "4-post-cabinet")
  weight         = try(each.value.weight, null)
  weight_unit    = try(each.value.weight_unit, "kg")
}

# Create Rack Reservations
resource "netbox_rack_reservation" "rack_reservations" {
  for_each = var.rack_reservations

  rack_id     = netbox_rack.racks[each.value.rack].id
  units       = each.value.units
  user_id     = each.value.user_id
  description = each.value.description
  tenant_id   = local.tenant_id_map[each.value.tenant]
}

# ######## END CONFIGURE RACKS ############
