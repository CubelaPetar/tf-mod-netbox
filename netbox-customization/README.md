# Netbox Terraform module

This module handles the Customizations section.

It currently handles:

- [x] Custom field choices
- [x] Custom fields
- [x] Custom tags

## Usage

```terraform
module "netbox-customization" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-customization"

  custom_field_choices = var.organizations.customizations.custom_field_choices
  custom_fields        = var.organizations.customizations.custom_fields
  custom_tags          = var.organizations.customizations.custom_tags
}
```

For a vars structure example check the `example/` folder.

## LICENSE

Check the LICENSE.md
