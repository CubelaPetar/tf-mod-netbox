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

# ######## CONFIGURE IPAM ############
# Add RIRs
resource "netbox_rir" "rirs" {
  for_each = { for rir in var.rirs : rir.name => rir }

  name = each.value.name

  description = try(each.value.description, null)
  is_private  = try(each.value.private, null)
  slug        = try(each.value.slug, null)
}

# Add Aggregates
resource "netbox_aggregate" "aggregates" {
  for_each = { for agg in var.aggregates : agg.prefix => agg }

  prefix = each.value.prefix

  description = try(each.value.description, null)
  rir_id      = try(netbox_rir.rirs[each.value.rir_name].id, null)
  tenant_id   = try(var.tenant_id_map[each.value.tenant], null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add Roles
resource "netbox_ipam_role" "roles" {
  for_each = { for role in var.roles : role.name => role }

  name = each.value.name

  description = try(each.value.description, null)
  slug        = try(each.value.slug, null)
  weight      = try(each.value.weight, null)
}

# Add VRFs
resource "netbox_vrf" "vrfs" {
  for_each = { for vrf in var.vrfs : vrf.name => vrf }

  name = each.value.name

  description    = try(each.value.description, null)
  enforce_unique = try(each.value.enforce_unique, null)
  rd             = try(each.value.rd, null)
  tenant_id      = try(var.tenant_id_map[each.value.tenant], null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add VLAN Groups
resource "netbox_vlan_group" "vlan_groups" {
  for_each = var.vlan_groups

  name    = each.value.name
  slug    = each.value.slug
  min_vid = each.value.min_vid
  max_vid = each.value.max_vid

  description = try(each.value.description, null)
  scope_type  = try(each.value.scope_type, null)
  scope_id = each.value.scope_type == null ? null : lookup({
    "dcim.location"  = try(var.location_id_map[each.value.scope], null),
    "dcim.site"      = try(var.site_id_map[each.value.scope], null),
    "dcim.sitegroup" = try(var.site_group_id_map[each.value.scope], null),
    "dcim.region"    = try(var.region_id_map[each.value.scope], null),
    "dcim.rack"      = try(local.rack_id_map[each.value.scope], null),

    // TODO: find way to add cluster and clustergroup without coupling to virtualization module
    # "virtualization.cluster" = var.cluster_id_map[each.value.scope]
    # "virtualization.clustergroup" = var.cluster_group_id_map[each.value.scope]
  }, each.value.scope_type)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add VLANs
resource "netbox_vlan" "vlans" {
  for_each = { for vlan in var.vlans : vlan.name => vlan }

  name = each.value.name
  vid  = each.value.vid

  description = try(each.value.description, null)
  group_id    = try(netbox_vlan_group.vlan_groups[each.value.group].id, null)
  role_id     = try(netbox_ipam_role.roles[each.value.role].id, null)
  status      = try(each.value.status, null)
  site_id     = try(var.site_id_map[each.value.site], null)
  tenant_id   = try(var.tenant_id_map[each.value.tenant], null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add Prefixes
resource "netbox_prefix" "prefixes" {
  for_each = { for prefix in var.prefixes : prefix.prefix => prefix }

  prefix = each.value.prefix
  status = each.value.status

  custom_fields = try(each.value.custom_fields, null)
  description   = try(each.value.description, null)
  is_pool       = try(each.value.is_pool, null)
  mark_utilized = try(each.value.mark_utilized, null)
  role_id       = try(netbox_ipam_role.roles[each.value.role].id, null)
  site_id       = try(var.site_id_map[each.value.site], null)
  tenant_id     = try(var.tenant_id_map[each.value.tenant], null)
  vlan_id       = try(netbox_vlan.vlans[each.value.vlan].id, null)
  vrf_id        = try(netbox_vrf.vrfs[each.value.vrf].id, null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add IP Ranges
resource "netbox_ip_range" "ranges" {
  for_each = { for range in var.ip_ranges : range.start_address => range }

  start_address = each.value.start_address
  end_address   = each.value.end_address

  description = try(each.value.description, null)
  role_id     = try(netbox_ipam_role.roles[each.value.role].id, null)
  status      = try(each.value.status, null)
  tenant_id   = try(var.tenant_id_map[each.value.tenant], null)
  vrf_id      = try(netbox_vrf.vrfs[each.value.vrf].id, null)

  lifecycle {
    ignore_changes = [tags]
  }
}

# Add IP Addresses
resource "netbox_ip_address" "addresses" {
  for_each = { for addr in var.ip_addresses : addr.ip_address => addr }

  ip_address = each.value.ip_address
  status     = each.value.status

  custom_fields = try(each.value.custom_fields, null)
  description   = try(each.value.description, null)
  dns_name      = try(each.value.dns_name, null)
  role          = try(each.value.role, null)
  tenant_id     = try(var.tenant_id_map[each.value.tenant], null)
  vrf_id        = try(netbox_vrf.vrfs[each.value.vrf].id, null)

  object_type  = try(each.value.object_type, null)
  interface_id = each.value.object_type == "dcim.interface" ? try(local.dev_interfaces_id_map[each.value.dev_interface], null) : try(local.vm_interface_id_map[each.value.virtual_machine_interface], null)

  # nat_inside_address_id        = try(each.value.nat_inside_address_id, null) // TODO: Add nat_inside_address_id

  lifecycle {
    ignore_changes = [tags, nat_inside_address_id]
  }
}

# Add Services
# resource "netbox_service" "services" {
#   for_each = { for service in var.services : service.name => service }

#   name     = each.value.name
#   protocol = each.value.protocol

#   custom_fields = try(each.value.custom_fields, null)
#   description   = try(each.value.description, null)
#   device_id     = try(each.value.device_id, null)
#   port          = try(each.value.port, null)
#   ports         = try(each.value.ports, null)
#   virtual_machine_id = try(netbox_virtual_machine.vms[each.value.virtual_machine_interface].id, null)

#   lifecycle {
#     ignore_changes = [ "tags", "virtual_machine_id" ]
#   }
# }
# ######## END CONFIGURE IPAM ############
