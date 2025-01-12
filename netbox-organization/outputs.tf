# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

output "tenant_groups" {
  description = "Managed tenant groups"
  value       = netbox_tenant_group.tenant_groups
}

output "tenants" {
  description = "Managed tenants"
  value       = netbox_tenant.tenants
}

output "regions" {
  description = "Managed regions"
  value       = netbox_region.regions
}

output "sites" {
  description = "Managed sites"
  value       = netbox_site.sites
}

output "site_groups" {
  description = "Managed site groups"
  value       = netbox_site_group.site_groups
}

output "locations" {
  description = "Managed locations"
  value       = netbox_location.locations
}

output "contacts" {
  description = "Managed contacts"
  value       = netbox_contact.contacts
}

output "contact_groups" {
  description = "Managed contact groups"
  value       = netbox_contact_group.contact_groups
}
