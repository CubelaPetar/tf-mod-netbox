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

# ######## LOOKUPS ############
data "netbox_site" "sites" {
  for_each = toset(var.sites)
  name     = each.value
}

data "netbox_tenant" "tenants" {
  for_each = toset(var.tenants)
  name     = each.value
}

data "netbox_location" "locations" {
  for_each = toset(var.locations)
  name     = each.value
}

data "netbox_region" "regions" {
  for_each = toset(var.regions)

  filter {
    name = each.value
  }
}

data "netbox_site_group" "site_groups" {
  for_each = toset(var.site_groups)
  name     = each.value
}
# ######## END LOOKUPS ############
