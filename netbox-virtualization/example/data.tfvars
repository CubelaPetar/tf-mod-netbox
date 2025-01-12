
organizations = {
  virtualization_config = {
    cluster_types = {
      VMware = {
        name = "VMware"
        slug = "vmware"
      },

      Kubernetes = {
        name = "Kubernetes"
        slug = "kubernetes"
      }
    }

    cluster_groups = {
      Production = {
        name        = "Production"
        description = "Production cluster group"
        slug        = "production"
      },

      Development = {
        name        = "Development"
        description = "Development cluster group"
        slug        = "development"
      }
    }

    clusters = {
      prod-vmware-01 = {
        name          = "prod-vmware-01"
        cluster_type  = "VMware" # Reference to VMware cluster type
        cluster_group = "Production"
        site          = "dc-east"
        tenant        = "main-org"
        description   = "Production VMware Cluster"
        tags          = ["production", "vmware"]
      },

      dev-k8s-01 = {
        name          = "dev-k8s-01"
        cluster_type  = "Kubernetes" # Reference to Kubernetes cluster type
        cluster_group = "Development"
        site          = "dc-west"
        tenant        = "main-org"
        description   = "Development Kubernetes Cluster"
        tags          = ["development", "kubernetes"]
      }
    }
  }
}
