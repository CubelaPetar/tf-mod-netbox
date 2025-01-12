# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

variable "cluster_types" {
  description = "List of cluster types to be created in NetBox"
  type = map(object({
    name = string
    slug = string
  }))

  default = {}
}

variable "cluster_groups" {
  description = "List of cluster groups to be created in NetBox"
  type = map(object({
    name        = string
    description = string
    slug        = string
  }))

  default = {}
}

variable "clusters" {
  description = "List of clusters to be created in NetBox"
  type = map(object({
    name          = string
    cluster_type  = string
    cluster_group = optional(string)
    site          = optional(string)
    tenant        = optional(string)
    comments      = optional(string)
    description   = optional(string)
    tags          = optional(list(string))
  }))

  default = {}
}

variable "vms" {
  description = "Map of virtual machines with their configurations"
  type = map(object({
    name               = string
    vcpus              = optional(number)
    memory_mb          = optional(number)
    platform           = optional(string)
    device             = optional(string)
    cluster            = optional(string)
    site               = optional(string)
    tenant             = optional(string)
    role               = optional(string)
    status             = optional(string)
    description        = optional(string)
    comments           = optional(string)
    custom_fields      = optional(map(any))
    local_context_data = optional(map(any), {})

    disks = object({
      name          = string
      size          = number
      description   = optional(string)
      custom_fields = optional(map(any))
    })

    networking = list(object({
      name          = string
      vm            = string
      description   = optional(string)
      enabled       = optional(bool, true)
      mac_address   = optional(string)
      vrf           = optional(string)
      mode          = optional(string, "access")
      mtu           = optional(number, "1500")
      tagged_vlans  = optional(list(number))
      untagged_vlan = optional(number)
      ip_address    = optional(string)
    }))

  }))

  default = {}

  validation {
    condition = alltrue([
      for iface in var.vms : alltrue([
        for net in iface.networking : contains(["access", "tagged", "tagged-all"], net.mode)
      ])
    ])
    error_message = "Interface mode must be one of 'access', 'tagged', or 'tagged-all'"
  }

}

variable "site_id_map" {
  description = "Map of site names to their IDs"
  type        = map(string)
}

variable "tenant_id_map" {
  description = "Map of tenant names to their IDs"
  type        = map(string)
}
