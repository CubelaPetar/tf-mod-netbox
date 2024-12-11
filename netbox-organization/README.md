# Netbox Terraform module

This module creates the organization structure in Netbox.

It manages the following categories:

- [x] Tenant Groups
- [x] Tenants
- [x] Regions
- [x] Site Groups
- [x] Sites
- [x] Locations
- [x] Contact Group,
- [x] Contacts
- [x] Contact roles

## Usage

```terraform
module "netbox-org" {
    source = "github.com/rendler-denis/tf-netbox-mod-organization"

    for_each = var.organizations

    tenant_groups  = each.value.org_info.tenant_groups
    tenants        = each.value.org_info.tenants
    regions        = each.value.org_info.regions
    sites          = each.value.org_info.sites
    site_groups    = each.value.org_info.site_groups
    locations      = each.value.org_info.locations
    contact_groups = each.value.org_info.contact_groups
    contacts       = each.value.org_info.contacts
}
```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md