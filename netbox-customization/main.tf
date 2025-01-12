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

# ######## CONFIGURE CUSTOMIZATION ############
locals {
  custom_field_choices = {
    for key, value in var.custom_field_choices : key => merge(value, {
      choices = [
        for choice in value.choices :
        [choice, title(choice)]
      ]
    })
  }
}

# Create Custom Field Choices
resource "netbox_custom_field_choice_set" "custom_field_choices" {
  for_each = var.custom_field_choices

  name                 = each.value.name
  extra_choices        = local.custom_field_choices[each.key].choices
  description          = try(each.value.description, null)
  order_alphabetically = try(each.value.order_alphabetically, false)
}

# Create Custom Fields
resource "netbox_custom_field" "custom_fields" {
  for_each = var.custom_fields

  name          = each.value.name
  type          = each.value.type
  content_types = each.value.content_types

  description        = try(each.value.description, null)
  required           = try(each.value.required, false)
  choice_set_id      = try(netbox_custom_field_choice_set.custom_field_choices[each.value.choice_set].id, null)
  default            = try(each.value.default, null)
  label              = try(each.value.label, null)
  weight             = try(each.value.weight, null)
  group_name         = try(each.value.group_name, null)
  validation_maximum = try(each.value.validation_maximum, null)
  validation_minimum = try(each.value.validation_minimum, null)
  validation_regex   = try(each.value.validation_regex, null)
}

# Create Custom Tags
resource "netbox_tag" "custom_tags" {
  for_each = var.custom_tags

  name        = each.value.name

  color_hex   = try(each.value.color_hex, "9e9e9e")
  slug        = try(each.value.slug, null)
  description = try(each.value.description, null)

  lifecycle {
    ignore_changes = [ tags ]
  }
}

# ######## END CONFIGURE CUSTOMIZATION ############
