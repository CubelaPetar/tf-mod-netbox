variable "cluster_types" {
  description = "List of cluster types to be created in NetBox"
  type = map(object({
    name = string
    slug = string
  }))
}

variable "cluster_groups" {
  description = "List of cluster groups to be created in NetBox"
  type = map(object({
    name        = string
    description = string
    slug        = string
  }))
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

    iface = object({
      name          = string
      description   = optional(string)
      enabled       = optional(bool)
      mac_address   = optional(string)
      mode          = optional(string)
      mtu           = optional(number)
      tagged_vlans  = optional(list(number))
      type          = optional(string)
      untagged_vlan = optional(number)
    })
  }))

  default = {}
}

variable "site_id_map" {
  description = "Map of site names to their IDs"
  type        = map(string)
}

variable "tenant_id_map" {
  description = "Map of tenant names to their IDs"
  type        = map(string)
}
