
organizations = {
  org1 = {
    org_info = {
      tenant_groups = {
        operations = {
          name        = "Operations"
          slug        = "ops"
          description = "Operations Teams"
        }
        engineering = {
          name        = "Engineering"
          slug        = "eng"
          description = "Engineering Teams"
        }
      }
      tenants = {
        it_ops = {
          name        = "IT Operations"
          slug        = "it-ops"
          description = "IT Operations Team"
          group       = "operations"
        }
        network = {
          name        = "Network Team"
          slug        = "network"
          description = "Network Operations Team"
          group       = "engineering"
        }
      }
      regions = {
        na = {
          name        = "North America"
          slug        = "na"
          description = "North American Region"
        }
        eu = {
          name        = "Europe"
          slug        = "eu"
          description = "European Region"
        }
      }
      site_groups = {
        production = {
          name        = "Production Sites"
          slug        = "prod-sites"
          description = "Production Data Centers"
        }
      }
      sites = {
        dc1 = {
          name             = "DC1"
          slug             = "dc1"
          status           = "active"
          description      = "Primary Data Center"
          physical_address = "123 Data Center Ave, Dallas, TX"
          group            = "production"
          tenant           = "network"
          facility         = "ala balaur"
          region           = "na"
        }
        dc2 = {
          name             = "DC2"
          slug             = "dc2"
          status           = "planned"
          description      = "Secondary Data Center"
          physical_address = "123 Data Center Ave, Dallas, TX"
          group            = "production"
          tenant           = "network"
          facility         = "ala bala"
        }
      }
      locations = {
        server_room_a = {
          name        = "Server Room A"
          slug        = "srv-room-a"
          site        = "dc1"
          description = "Primary Server Room"
          tenant      = "it_ops"
          status      = "active"
        }
        server_room_b = {
          name        = "Server Room B"
          slug        = "srv-room-b"
          site        = "dc2"
          description = "Secondary Server Room"
          tenant      = "network"
          status      = "active"
        }
      }
      contacts = {
        dc_manager = {
          name  = "John Smith"
          email = "john.smith@example.com"
          phone = "555-01001"
          group = "dc_ops"
        }
      }
      contact_groups = {
        dc_ops = {
          name        = "DC Operations"
          slug        = "dc-ops"
          description = "Data Center Operations Team"
        }
      }
      contact_roles = [
        {
          name        = "Engineer"
        },
        {
          name        = "Manager"
        }
      ]
    }
  }
}
