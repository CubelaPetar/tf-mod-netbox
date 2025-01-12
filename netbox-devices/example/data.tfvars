
organizations = {
  device_config = {
    device_roles = {
      "core_switch" = {
        color_hex   = "ffeb3b"
        name        = "Core Switch"
        slug        = "core-switch"
        description = "Core network switching equipment"
        vm_role     = false
        # tags        = ["network", "core"]
      }
      "firewall" = {
        color_hex = "000000"
        name      = "Firewall"
        slug      = "firewall"
        vm_role   = false
        # tags      = ["security", "network"]
      }
      "server" = {
        color_hex   = "008000"
        name        = "Server"
        slug        = "server"
        description = "Physical compute servers"
        vm_role     = true
      }
    }

    manufacturers = {
      "cisco" = {
        name = "Cisco Systems"
        slug = "cisco"
      }
      "juniper" = {
        name = "Juniper Networks"
        slug = "juniper"
      }
      "dell" = {
        name = "Dell Technologies"
        slug = "dell"
      }
    }

    device_types = {
      "c9300-48p" = {
        manufacturer  = "cisco"
        model         = "Catalyst 9300-48P"
        slug          = "c9300-48p"
        height        = 1
        is_full_depth = true
        part_number   = "C9300-48P-A"
        tags          = ["switching", "poe"]
      }
      "srx3600" = {
        manufacturer  = "juniper"
        model         = "SRX3600"
        slug          = "srx3600"
        height        = 3
        is_full_depth = true
        part_number   = "SRX3600-BASE"
        tags          = ["firewall", "routing"]
      }
      "r640" = {
        manufacturer  = "dell"
        model         = "PowerEdge R640"
        slug          = "poweredge-r640"
        height        = 1
        is_full_depth = true
        part_number   = "R640-BASE"
        tags          = ["compute", "server"]
      }
    }

    platforms = {
      "ios_xe" = {
        name         = "Cisco IOS-XE"
        slug         = "ios-xe"
        manufacturer = "cisco"
      }
      "junos" = {
        name         = "Juniper JUNOS"
        slug         = "junos"
        manufacturer = "juniper"
      }
      "idrac9" = {
        name         = "Dell iDRAC 9"
        slug         = "idrac9"
        manufacturer = "dell"
      }
    }

    devices = {
      "core-sw-01" = {
        name          = "core-sw-01"
        role          = "core_switch"
        type          = "c9300-48p"
        site          = "DC1"
        tenant        = "IT Operations"
        location      = "Server Room B"
        platform      = "ios_xe"
        rack          = "NET-RACK-02"
        rack_face     = "front"
        rack_position = 30
        serial        = "FCW2321L0R3"
        status        = "active"
        asset_tag     = "NET001"
        description   = "Primary Core Switch"
      }
      "fw-01" = {
        name          = "fw-01"
        site          = "DC1"
        role          = "firewall"
        type          = "srx3600"
        tenant        = "IT Operations"
        location      = "Server Room A"
        platform      = "junos"
        rack          = "NET-RACK-01"
        rack_face     = "front"
        rack_position = 25
        serial        = "JN2345ABCDEF"
        status        = "active"
        asset_tag     = "SEC001"
        description   = "Primary Firewall"

      }
      "srv-db-01" = {
        name          = "srv-db-01"
        site          = "DC1"
        role          = "server"
        type          = "r640"
        tenant        = "IT Operations"
        location      = "Server Room A"
        platform      = "idrac9"
        rack          = "NET-RACK-01"
        rack_face     = "front"
        rack_position = 15
        serial        = "2DR7NM2"
        status        = "active"
        asset_tag     = "SRV001"
        description   = "Primary Database Server"
        local_context_data = {
          role          = "database"
          cluster       = "db-cluster-01"
          backup_window = "01:00-03:00"
        }
      }
      "srv-db-02" = {
        name        = "srv-db-02"
        site        = "DC1"
        role        = "server"
        type        = "r640"
        tenant      = "IT Operations"
        location    = "Server Room A"
        platform    = "idrac9"
        serial      = "2DR7NM2-2"
        status      = "active"
        asset_tag   = "SRV001-2"
        description = "Secondary Database Server"
        rack        = "NET-RACK-01"
        local_context_data = {
          role          = "database"
          cluster       = "db-cluster-01"
          backup_window = "01:00-03:00"
        }
      }
    }
  }
}
