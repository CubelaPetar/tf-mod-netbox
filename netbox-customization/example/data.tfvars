
organizations = {
  org1 = {
    customizations = {
      custom_field_choices = {
        "environment" = {
          name                 = "Environment"
          choices              = ["production", "staging", "development"]
          description          = "Environment types"
          order_alphabetically = true
        }
        "status_options" = {
          name        = "Status Options"
          choices     = ["active", "pending", "retired"]
          description = "Status options for assets"
        }
      }

      custom_fields = {
        "environment_type" = {
          name          = "environment_type"
          type          = "select"
          content_types = ["virtualization.virtualmachine"]
          description   = "Environment classification"
          required      = true
          choice_set    = "environment"
          label         = "Environment Type"
          group_name    = "Asset Information"
        }
        "asset_value" = {
          name               = "asset_value"
          type               = "integer"
          content_types      = ["dcim.device"]
          description        = "Asset value in dollars"
          validation_minimum = 0
          validation_maximum = 1000000
          group_name         = "Asset Information"
        }
      }

      custom_tags = {
        "production" = {
          name        = "Production"
          color_hex   = "ff0000"
          description = "Production environment"
          tags        = ["critical", "monitored"]
        }
        "development" = {
          name        = "Development"
          color_hex   = "00ff00"
          description = "Development environment"
          tags        = ["non-critical"]
        }
      }

    }
  }
}
