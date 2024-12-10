# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-device
# License: Check the LICENSE file or the repository for the license of the module.

variable "device_roles" {
  description = "Map of device roles configurations"
  type = map(object({
    color_hex   = string
    name        = string
    slug        = string
    description = optional(string)
    tags        = optional(list(string))
    vm_role     = optional(bool)
  }))
  default = {}
}

variable "manufacturers" {
  description = "Map of manufacturer configurations"
  type = map(object({
    name = string
    slug = string
  }))
  default = {}
}

variable "device_types" {
  description = "Map of device type configurations"
  type = map(object({
    manufacturer  = string
    model         = string
    slug          = string
    height        = number
    is_full_depth = optional(bool)
    part_number   = optional(string)
    tags          = optional(list(string))
  }))
  default = {}
}

variable "platforms" {
  description = "Map of platform configurations"
  type = map(object({
    name         = string
    slug         = string
    manufacturer = string
  }))
  default = {}
}

variable "devices" {
  description = "Map of device configurations"
  type = map(object({
    name               = string
    site               = string
    role               = string
    type               = string
    platform           = string
    tenant             = optional(string)
    location           = optional(string)
    asset_tag          = optional(string)
    cluster            = optional(string)
    comments           = optional(string)
    custom_fields      = optional(map(any))
    config_template    = optional(string)
    description        = optional(string)
    local_context_data = optional(map(any))
    rack               = optional(string)
    rack_face          = optional(string)
    rack_position      = optional(number)
    serial             = optional(string)
    status             = optional(string)
  }))
  default = {}
}
