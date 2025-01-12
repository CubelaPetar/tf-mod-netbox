# Netbox Terraform module

This module manages the virtual machines in Netbox.

It manages the following sections:

- [x] cluster types
- [x] cluster groups
- [x] cluster
- [x] virtual machines
- [x] virtual machine - disks
- [x] virtual machine - network interface

## Usage

```hcl
module "netbox-virtualization" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-virtualization"

  depends_on = [module.netbox-org-data]

  cluster_types  = var.organizations.virtualization_config.cluster_types
  cluster_groups = var.organizations.virtualization_config.cluster_groups
  clusters       = var.organizations.virtualization_config.clusters

  site_id_map   = module.netbox-org-data[each.key].sites_map
  tenant_id_map = module.netbox-org-data[each.key].tenants_map
}
```

You can also just manage the virtual machine information and use this module
as part of your existing Terraform/OpenTofu code.

```hcl
module "netbox-vm-documentation" {
  source = "github.com/rendler-denis/tf-mod-netbox//netbox-virtualization"

  depends_on = [ module.netbox-org-data ]

  vms = {
    your_vm_name = {
      name   = your_vm_name
      target = try(var.your_vm_info_var.target, null)

      vcpus       = var.your_vm_info_var.cpu_cores,
      memory_mb   = var.your_vm_info_var.memory,
      vmid        = var.your_vm_info_var.vmid,
      state       = try(var.your_vm_info_var.state, "offline")
      description = var.your_vm_info_var.description,
      role        = var.your_vm_info_var.role_name,
      platform    = var.your_vm_info_var.platform_name,
      site        = var.your_vm_info_var.site_name,
      tenant      = var.your_vm_info_var.tenant_name,
      cluster     = var.your_vm_info_var.cluster_name,
      device      = var.your_vm_info_var.device_name,

      disks = {
        name        = "System disk (your_vm_name)"
        size        = tonumber(replace(try(var.your_vm_info_var.hdd_size, "0"), "/[GM]/", "")) * lookup(local.size_map, substr(var.your_vm_info_var.hdd_size, -1, 1), 1)
        description = "System Disk on your_vm_name"
        custom_fields = {
          // example of custom field for vm disks
          storage_name = try(var.your_vm_info_var.storage_name, null)
        }
      }

      networking = [
        {
          ip_address    = try(var.your_vm_info_var.net.ip, null)
          name          = "your_vm_name [eth0]"
          vm            = your_vm_name
          description   = "Main network interface"
          enabled       = true
          mac_address   = try(var.your_vm_info_var.net.macaddr, null)
          mode          = try(var.your_vm_info_var.net.mode, "access")
          tagged_vlans  = var.your_vm_info_var.net.tag != 0 ? (try(var.your_vm_info_var.net.tagged, false) ? [var.your_vm_info_var.net.tag] : null) : null
          untagged_vlan = var.your_vm_info_var.net.tag != 0 ? (!try(var.your_vm_info_var.net.tagged, true) ? var.your_vm_info_var.net.tag : null) : null
          dns           = try(var.your_vm_info_var.net.dns, null)
        }
      ]

      services = try(var.your_vm_info_var.services, {})
      custom_fields = merge({
        custom_field_1  = try(var.your_vm_info_var.custom_field_1, null)
        custom_field_2  = try(var.your_vm_info_var.custom_field_2, null)
        ...
        }
      , try(var.your_vm_info_var.custom_fields, {}))
    }
  }

  site_id_map   = module.netbox-org-data.sites_map
  tenant_id_map = module.netbox-org-data.tenants_map
}

```

For a data example check the example folder.

## LICENSE

Check the LICENSE.md
