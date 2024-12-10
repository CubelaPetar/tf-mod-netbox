# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2024-2025 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-netbox-mod-racks
# License: Check the LICENSE file or the repository for the license of the module.

output "rack_roles" {
  description = "Created rack roles"
  value       = netbox_rack_role.rack_roles
}

output "racks" {
  description = "Created racks"
  value       = netbox_rack.racks
}
