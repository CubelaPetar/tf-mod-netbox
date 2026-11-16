# Author: Petar Cubela <mail@petarcubela.de>
# Copyright: 2025-2030 Denis Rendler
# Orig Repository: https://github.com/rendler-denis/tf-mod-netbox
# Repository: https://github.com/CubelaPetar/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

variable "devices" {
  description = "Map of devices with their primary IP addresses"
  type        = map(string)

  default = {}
}

variable "vms" {
  description = "Map of virtual machines with their primary IP addresses"
  type        = map(string)

  default = {}
}
