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