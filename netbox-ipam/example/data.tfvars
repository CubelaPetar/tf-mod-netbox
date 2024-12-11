organizations = {
  org1 = {
    ipam_config = {
      rirs = {
        arin = {
          name        = "ARIN"
          description = "American Registry for Internet Numbers"
          private     = false
          slug        = "arin"
        },
        rfc1918 = {
          name        = "RFC1918"
          description = "Private Address Space"
          private     = true
          slug        = "rfc1918"
        }
      }

      aggregates = [
        {
          prefix      = "10.0.0.0/8"
          description = "Private Network Space"
          rir_name    = "RFC1918"
          tenant      = "main"
          tags        = ["private"]
        },
        {
          prefix      = "172.16.0.0/12"
          description = "Secondary Private Network"
          rir_name    = "RFC1918"
          tenant      = "main"
        }
      ]

      roles = {
        production = {
          name        = "Production"
          description = "Production Network"
          slug        = "production"
          weight      = 1000
        },
        development = {
          name        = "Development"
          description = "Development Network"
          slug        = "development"
          weight      = 500
        }
      }

      vrfs = {
        main = {
          name           = "main"
          description    = "Main VRF"
          enforce_unique = true
          rd             = "65000:1"
          tags           = ["production"]
          tenant         = "main"
        }
      }

      vlan_groups = {
        production = {
          name        = "Production"
          slug        = "production"
          min_vid     = 110
          max_vid     = 299
          description = "Production VLANs",

          // Scope to a region
          scope      = "NET-RACK-01"
          scope_type = "dcim.rack"
        }
      }

      vlans = {
        prod-vlan = {
          name        = "Production-LAN"
          vid         = 100
          description = "Production LAN"
          group       = "Production"
          role        = "Production"
          status      = "active"
          tags        = ["production"]
          site        = "main"
          tenant      = "main"
        }
      }

      prefixes = {
        prod = {
          prefix      = "10.1.0.0/16"
          status      = "active"
          description = "Production Network"
          is_pool     = true
          role        = "Production"
          tags        = ["production"]
          site        = "main"
          tenant      = "main"
          vrf         = "main"
        }
      }

      ip_ranges = [
        {
          start_address = "10.1.1.1"
          end_address   = "10.1.1.254"
          description   = "Production DHCP Range"
          role          = "Production"
          status        = "active"
          tags          = ["dhcp"]
          tenant        = "main"
          vrf           = "main"
        }
      ]

      ip_addresses = [
        {
          ip_address  = "10.1.1.1/24"
          status      = "active"
          description = "Gateway"
          dns_name    = "gateway.example.com"
          role        = "anycast"
          tags        = ["infrastructure"]
          tenant      = "main"
          vrf         = "main"
          custom_fields = {
            vlan : "core-sw-01"
          }
        },
        {
          ip_address  = "10.100.100.100/24"
          status      = "active"
          description = "qwerty-test"
          dns_name    = "gateway.example.com"
          role        = "secondary"
          tags        = ["infrastructure"]
          tenant      = "main"
          vrf         = "main"
          custom_fields = {
            vlan : "core-sw-01"
          },

          object_type   = "dcim.interface"
          dev_interface = "dddd"
        }
      ]
    }
  }
}
