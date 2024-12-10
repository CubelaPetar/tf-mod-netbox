
organizations = {
  org1 = {
    rack_config = {
      rack_roles = {
        network = {
          name        = "Network"
          slug        = "network"
          color       = "ff0000"
          description = "Network Equipment"
        }
      }
      racks = {
        net_rack_01 = {
          name     = "NET-RACK-01"
          site     = "DC1"
          tenant   = "IT Operations"
          location = "Server Room A"
          status   = "active"
          width    = 19
          u_height = 42
          role     = "network"
          facility = "A1"
          type     = "4-post-frame"
          tags     = ["production", "network"]
        }
        net_rack_02 = {
          name     = "NET-RACK-02"
          site     = "DC2"
          tenant   = "IT Operations"
          location = "Server Room B"
          status   = "active"
          width    = 19
          u_height = 42
          role     = "network"
          facility = "A1"
          type     = "4-post-frame"
          tags     = ["production", "network"]
        }
      }
      rack_reservations = {
        maintenance = {
          rack        = "net_rack_01"
          units       = [40, 41, 42, 10, 11, 12, 1, 2, 3, 4]
          user_id     = 1
          description = "Reserved for maintenance"
          tenant      = "IT Operations"
        }
      }
    }
  }
}
