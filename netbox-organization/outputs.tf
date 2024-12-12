# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-organization
# License: Check the LICENSE file or the repository for the license of the module.
#
# This module creates the organization structure in Netbox.
# It creates Tenant Groups, Tenants, Regions, Site Groups, Sites, Locations, Contact Groups, and Contacts.

output "tenant_groups" {
  description = "Created tenant groups"
  value       = netbox_tenant_group.tenant_groups
}

output "tenants" {
  description = "Created tenants"
  value       = netbox_tenant.tenants
}

output "regions" {
  description = "Created regions"
  value       = netbox_region.regions
}

output "sites" {
  description = "Created sites"
  value       = netbox_site.sites
}

output "site_groups" {
  description = "Created site groups"
  value       = netbox_site_group.site_groups
}

output "locations" {
  description = "Created locations"
  value       = netbox_location.locations
}

output "contacts" {
  description = "Created contacts"
  value       = netbox_contact.contacts
}

output "contact_groups" {
  description = "Created contact groups"
  value       = netbox_contact_group.contact_groups
}

# output "xxx" {
#   description = "Created xxx"
#   value       = netbox_location.child_locations
# }

# output "yyy" {
#   description = "Created yyy"
#   value       = netbox_location.locations

# }
