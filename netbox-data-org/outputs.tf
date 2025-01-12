# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

output "sites_map" {
  description = "Map of site names to their IDs"
  value = {
    for name, site in data.netbox_site.sites : name => site.id
  }
}

output "tenants_map" {
  description = "Map of tenant names to their IDs"
  value = {
    for name, tenant in data.netbox_tenant.tenants : name => tenant.id
  }
}

output "locations_map" {
  description = "Map of location names to their IDs"
  value = {
    for name, location in data.netbox_location.locations : name => location.id
  }
}

output "regions_map" {
  description = "Map of region names to their IDs"
  value = {
    for name, region in data.netbox_region.regions : name => region.id
  }
}

output "site_groups_map" {
  description = "Map of site group names to their IDs"
  value = {
    for name, site_group in data.netbox_site_group.site_groups : name => site_group.id
  }
}