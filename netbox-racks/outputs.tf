# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

output "rack_roles" {
  description = "Managed rack roles"
  value       = netbox_rack_role.rack_roles
}

output "racks" {
  description = "Managed racks"
  value       = netbox_rack.racks
}
