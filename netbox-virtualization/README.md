# Netbox Terraform module

This module manages the virtual machines in Netbox.

It manages the following sections:

- [x] cluster
- [x] cluster types
- [x] virtual machines
- [x] virtual machine - disk
- [x] virtual machine - interfaces

## Usage

```hcl
module "netbox-virtualization" {
  source = "github.com/rendler-denis/tf-mod-netbox"

  depends_on = [module.netbox-org, module.netbox-org-data]

  for_each = var.organizations

  cluster_types  = each.value.virtualization_config.cluster_types
  cluster_groups = each.value.virtualization_config.cluster_groups
  clusters       = each.value.virtualization_config.clusters
  vms            = each.value.virtualization_config.vms

  site_id_map   = module.netbox-org-data[each.key].sites_map
  tenant_id_map = module.netbox-org-data[each.key].tenants_map
}
```

For a data example check the example folder.

The module will automatically lookup the organization information by name.

## LICENSE

Check the LICENSE.md
