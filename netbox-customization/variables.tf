# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-customization
# License: Check the LICENSE file or the repository for the license of the module.

variable "custom_field_choices" {
  description = "Map of custom field choice sets"
  type = map(object({
    name                 = string
    choices              = list(string)
    description          = optional(string)
    order_alphabetically = optional(bool)
  }))
  default = {}
}

variable "custom_fields" {
  description = "Map of custom fields configurations"
  type = map(object({
    name               = string
    type               = string
    content_types      = list(string)
    description        = optional(string)
    required           = optional(bool)
    choice_set         = optional(string)
    default            = optional(string)
    label              = optional(string)
    weight             = optional(number)
    group_name         = optional(string)
    validation_maximum = optional(number)
    validation_minimum = optional(number)
    validation_regex   = optional(string)
  }))
  default = {}
}

variable "custom_tags" {
  description = "Map of custom tags configurations"
  type = map(object({
    name        = string
    color_hex   = optional(string)
    slug        = optional(string)
    description = optional(string)
    tags        = optional(list(string))
  }))
  default = {}
}
