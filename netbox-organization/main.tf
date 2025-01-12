# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "=3.9.2"
    }
  }
}

# ######## CONFIGURE ORGANIZATION ############

# Create Tenant Groups
resource "netbox_tenant_group" "tenant_groups" {
  for_each = var.tenant_groups

  name        = each.value.name
  slug        = each.value.slug
  description = try(each.value.description, null)
}

# Create tenants
resource "netbox_tenant" "tenants" {
  for_each = var.tenants

  name        = each.value.name
  slug        = try(each.value.slug, null)
  description = try(each.value.description, null)
  group_id    = each.value.group != null ? netbox_tenant_group.tenant_groups[each.value.group].id : null
}

# Create Regions
resource "netbox_region" "regions" {
  for_each = var.regions

  name        = each.value.name
  slug        = try(each.value.slug, null)
  description = try(each.value.description, null)
}

# Create Site Groups
resource "netbox_site_group" "site_groups" {
  for_each = var.site_groups

  name        = each.value.name
  slug        = try(each.value.slug, null)
  description = try(each.value.description, null)
  parent_id   = try(each.value.parent_id, null)
}

# Create site
resource "netbox_site" "sites" {
  for_each = var.sites

  name             = each.value.name
  slug             = each.value.slug
  description      = each.value.description
  status           = each.value.status
  physical_address = each.value.physical_address
  timezone         = each.value.timezone
  group_id         = each.value.group != null ? netbox_site_group.site_groups[each.value.group].id : null
  tenant_id        = each.value.tenant != null ? netbox_tenant.tenants[each.value.tenant].id : null
  facility         = each.value.facility
  latitude         = each.value.latitude
  longitude        = each.value.longitude
  region_id        = each.value.region != null ? netbox_region.regions[each.value.region].id : null
}

# Create Locations
resource "netbox_location" "locations" {
  for_each = var.locations

  name        = each.value.name
  slug        = each.value.slug
  site_id     = each.value.site != null ? netbox_site.sites[each.value.site].id : null
  tenant_id   = each.value.tenant != null ? netbox_tenant.tenants[each.value.tenant].id : null
  description = each.value.description

  lifecycle {
    ignore_changes = [parent_id]
  }
}

# Create Contact Groups
resource "netbox_contact_group" "contact_groups" {
  for_each = var.contact_groups

  name        = each.value.name
  slug        = each.value.slug
  description = each.value.description
}

# Create Contacts
resource "netbox_contact" "contacts" {
  for_each = var.contacts

  name     = each.value.name
  email    = each.value.email
  phone    = each.value.phone
  group_id = each.value.group != null ? netbox_contact_group.contact_groups[each.value.group].id : null
}

resource "netbox_contact_role" "contact_roles" {
  for_each = { for role in var.contact_roles : role.name => role }

  name = each.value.name
}
# ######## END CONFIGURE ORGANIZATION ############
