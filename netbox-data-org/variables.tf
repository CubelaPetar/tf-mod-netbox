# Author: Denis Rendler <connect@rendler.net>
# Copyright: 2025-2030 Denis Rendler
# Repository: https://github.com/rendler-denis/tf-mod-netbox
# License: Check the LICENSE file or the repository for the license of the module.

variable "sites" {
  description = "List of site names to retrieve from Netbox"
  type        = list(string)
  default     = []
}

variable "tenants" {
  description = "List of tenant names to retrieve from Netbox"
  type        = list(string)
  default     = []
}

variable "locations" {
  description = "List of location names to retrieve from Netbox"
  type        = list(string)
  default     = []
}

variable "regions" {
  description = "List of region names to retrieve from Netbox"
  type        = list(string)
  default     = []
}

variable "site_groups" {
  description = "List of site group names to retrieve from Netbox"
  type        = list(string)
  default     = []
}