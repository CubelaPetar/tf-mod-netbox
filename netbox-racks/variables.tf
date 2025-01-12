# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

variable "rack_roles" {
  description = "List of rack roles to create"
  type = map(object({
    name        = string
    slug        = optional(string)
    color       = optional(string)
    description = optional(string)
  }))
  default = {}
}

variable "racks" {
  description = "List of racks to create"
  type = map(object({
    # Required fields
    name     = string
    site     = string # References site name
    status   = string
    width    = number # Required rack width (10, 19 or 23)
    u_height = number # Height in rack units

    # Optional fields
    asset_tag      = optional(string)
    comments       = optional(string)
    custom_fields  = optional(map(any))
    desc_units     = optional(bool)
    description    = optional(string)
    facility       = optional(string)
    location       = optional(string)
    max_weight     = optional(number)
    mounting_depth = optional(number)
    outer_depth    = optional(number)
    outer_unit     = optional(string)
    outer_width    = optional(number)
    role           = optional(string)
    serial         = optional(string)
    tags           = optional(set(string))
    tenant         = optional(string)
    type           = optional(string)
    weight         = optional(number)
    weight_unit    = optional(string)
  }))

  validation {
    condition = alltrue([
      for rack in var.racks : contains([10, 19, 23], rack.width)
    ])
    error_message = "Rack width must be either 10, 19 or 23 inches."
  }

  validation {
    condition = alltrue([
      for rack in var.racks : rack.u_height > 0
    ])
    error_message = "Rack height must be greater than 0 units."
  }

  validation {
    condition = alltrue([
      for rack in var.racks : contains(["active", "planned", "reserved", "retired"], rack.status)
    ])
    error_message = "Rack status must be one of: active, planned, reserved, or retired."
  }

  default = {}
}

variable "rack_reservations" {
  description = "List of rack reservations to create"
  type = map(object({
    rack        = string
    units       = set(number)
    user_id     = number
    description = optional(string)
    tenant      = optional(string)
  }))
  default = {}
}

variable "site_id_map" {
  description = "Mapping of site names to IDs"
  type        = map(number)
  default     = {}
}

variable "location_id_map" {
  description = "Mapping of location names to IDs"
  type        = map(number)
  default     = {}
}

variable "tenant_id_map" {
  description = "Mapping of tenant names to IDs"
  type        = map(number)
  default     = {}
}
