# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2029 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

# Variables definitions
variable "rirs" {
  description = "List of Regional Internet Registries"
  type = map(object({
    name        = string
    description = optional(string)
    private     = optional(bool)
    slug        = optional(string)
  }))
  default = {}
}

variable "aggregates" {
  description = "List of IP aggregates"
  type = list(object({
    prefix      = string
    description = optional(string)
    rir_name    = optional(string)
    tenant      = optional(string)
    tags        = optional(list(string))
  }))
  default = []
}

variable "roles" {
  description = "List of IPAM roles"
  type = map(object({
    name        = string
    description = optional(string)
    slug        = optional(string)
    weight      = optional(number)
  }))
  default = {}
}

variable "vrfs" {
  description = "List of VRFs"
  type = map(object({
    name           = string
    description    = optional(string)
    enforce_unique = optional(bool)
    rd             = optional(string)
    tags           = optional(list(string))
    tenant         = optional(string)
  }))
  default = {}
}

variable "vlan_groups" {
  description = "List of VLAN groups"
  type = map(object({
    name        = string
    slug        = string
    min_vid     = number
    max_vid     = number
    description = optional(string)
    scope       = optional(string)
    scope_type  = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for group in var.vlan_groups :
      group.scope_type == null ? true : contains([
        "dcim.location",
        "dcim.site",
        "dcim.sitegroup",
        "dcim.region",
        "dcim.rack",
        "virtualization.cluster",
        "virtualization.clustergroup"
      ], group.scope_type)
    ])
    error_message = "scope_type must be one of: dcim.location, dcim.site, dcim.sitegroup, dcim.region, dcim.rack, virtualization.cluster, virtualization.clustergroup"
  }
}

variable "vlans" {
  description = "List of VLANs"
  type = map(object({
    name        = string
    vid         = number
    description = optional(string)
    group       = optional(string)
    role        = optional(string)
    status      = optional(string)
    tags        = optional(list(string))
    site        = optional(string)
    tenant      = optional(string)
  }))
  default = {}
}

variable "prefixes" {
  description = "List of IP prefixes"
  type = map(object({
    prefix        = string
    status        = string
    custom_fields = optional(map(string))
    description   = optional(string)
    is_pool       = optional(bool)
    mark_utilized = optional(bool)
    role          = optional(string)
    tags          = optional(list(string))
    site          = optional(string)
    tenant        = optional(string)
    vlan          = optional(string)
    vrf           = optional(string)
  }))
  default = {}
}

variable "ip_ranges" {
  description = "List of IP ranges"
  type = list(object({
    start_address = string
    end_address   = string
    description   = optional(string)
    role          = optional(string)
    status        = optional(string)
    tags          = optional(list(string))
    tenant        = optional(string)
    vrf           = optional(string)
  }))
  default = []
}

variable "ip_addresses" {
  description = "List of IP addresses"
  type = list(object({
    ip_address    = string
    status        = string
    custom_fields = optional(map(string))
    description   = optional(string)
    dns_name      = optional(string)
    role          = optional(string)
    tags          = optional(list(string))
    tenant        = optional(string)
    vrf           = optional(string, "main")

    object_type                  = optional(string)
    dev_interface                 = optional(string)
    virtual_machine_interface = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for addr in var.ip_addresses :
      addr.role == null || contains(["loopback", "secondary", "anycast", "vip", "vrrp", "hsrp", "glbp", "carp"], addr.role)
    ])
    error_message = "role must be one of: loopback, secondary, anycast, vip, vrrp, hsrp, glbp, carp"
  }

  validation {
    condition = alltrue([
      for addr in var.ip_addresses :
      addr.object_type == null ? true : contains(["virtualization.vminterface", "dcim.interface"], addr.object_type)
    ])
    error_message = "object_type must be one of: virtualization.vminterface, dcim.interface"
  }

  validation {
    condition = alltrue([
      for addr in var.ip_addresses :
      (addr.dev_interface == null && addr.virtual_machine_interface == null) ||
      (addr.dev_interface != null && addr.virtual_machine_interface == null) ||
      (addr.dev_interface == null && addr.virtual_machine_interface != null)
    ])
    error_message = "Only one of interface_id, device_interface_id, or virtual_machine_interface_id can be set"
  }
}

variable "services" {
  description = "List of services"
  type = map(object({
    name          = string
    protocol      = string
    custom_fields = optional(map(string))
    description   = optional(string)
    device_id     = optional(number)
    port          = optional(number)
    ports         = optional(list(number))
    tags          = optional(list(string))
  }))
  default = {}
}

variable "site_id_map" {
  description = "Mapping of site names to IDs"
  type        = map(number)
  default     = {}
}

variable "site_group_id_map" {
  description = "Mapping of site group names to IDs"
  type        = map(number)
  default     = {}
}

variable "tenant_id_map" {
  description = "Mapping of tenant names to IDs"
  type        = map(number)
  default     = {}
}

variable "location_id_map" {
  description = "Mapping of location names to IDs"
  type        = map(number)
  default     = {}
}

variable "region_id_map" {
  description = "Mapping of region names to IDs"
  type        = map(number)
  default     = {}
}

variable "rack_id_map" {
  description = "Mapping of rack names to IDs"
  type        = map(number)
  default     = {}
}

