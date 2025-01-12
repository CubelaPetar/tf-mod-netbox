# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

output "device_rack_assignments" {
  description = "Rack assignments for each device"
  value = {
    for name, device in var.devices : name => {
      rack_name     = device.rack
      rack_id       = try(local.rack_id_map[device.rack][0], "not_found")
      rack_face     = device.rack_face
      rack_position = device.rack_position
    } if device.rack != null
  }
}
