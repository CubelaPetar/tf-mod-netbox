# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-organization
# License: Check the LICENSE file or the repository for the license of the module.
#
# This module creates the organization structure in Netbox.
# It creates Tenant Groups, Tenants, Regions, Site Groups, Sites, Locations, Contact Groups, and Contacts.

variable "tenant_groups" {
  description = "List of tenants to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    description = optional(string)
  }))
  default = {}
}

variable "tenants" {
  description = "List of tenants to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    description = optional(string)
    group       = optional(string)
  }))
  default = {}
}

variable "regions" {
  description = "List of regions to create"
  type = map(object({
    name             = string
    slug             = optional(string)
    description      = optional(string)
    parent_region_id = optional(number)
  }))
  default = {}
}

variable "site_groups" {
  description = "List of site groups to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    description = optional(string)
    parent_id   = optional(number)
  }))
  default = {}
}

variable "sites" {
  description = "List of sites to create"
  type = map(object({
    name             = string
    slug             = optional(string)
    status           = string
    description      = optional(string)
    physical_address = optional(string)
    timezone         = optional(string)
    group            = optional(string)
    tenant           = optional(string)
    facility         = optional(string)
    latitude         = optional(string)
    longitude        = optional(string)
    region           = optional(string)
  }))
  default = {}
}

variable "locations" {
  description = "List of locations to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    site        = string
    parent      = optional(string)
    description = optional(string)
    tenant      = optional(string)
    status      = optional(string, "active")
  }))
  default = {}
}

variable "contact_groups" {
  description = "List of contact groups to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    parent_id   = optional(number)
    description = optional(string)
  }))
  default = {}
}

variable "contacts" {
  description = "List of contacts to create"
  type = map(object({
    name  = string
    email = string
    phone = optional(string)
    group = optional(string)
  }))
  default = {}
}

variable "contact_roles" {
  description = "List of contact roles to create"
  type = list(object({
    name = string
  }))
  default = []
}
