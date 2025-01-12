# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

output "managed_customizations" {
  description = "Managed customizations"
  value = {
    custom_fields = {
      for custom_field in netbox_custom_field.custom_fields :
      custom_field.name => {
        id   = custom_field.id
        name = custom_field.name
        type = custom_field.type
      }
    },
    custom_tags = {
      for custom_tag in netbox_tag.custom_tags :
      custom_tag.name => {
        id   = custom_tag.id
        name = custom_tag.name
        slug = custom_tag.slug
      }
    }
  }
}
