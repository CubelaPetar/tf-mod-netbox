# Netbox Terraform module

This module handles the Customizations section.

It currently handles:

- [x] Custom field choices
- [x] Custom fields
- [x] Custom tags

## Usage

```terraform
module "netbox-customization" {
  source = "github.com/rendler-denis/tf-netbox-mod-customization"

  for_each = var.organizations

  custom_field_choices = each.value.customizations.custom_field_choices
  custom_fields        = each.value.customizations.custom_fields
  custom_tags          = each.value.customizations.custom_tags
}
```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md
