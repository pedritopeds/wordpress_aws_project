#K8s Service create
resource "kubernetes_service" "kubeservice" {
  metadata {
    name = "wordpress"
    labels = {
      "app" = "wordpress"
    }
  }
  spec {
    selector = {
      "app"  = "wordpress"
      "tier" = "frontend"
    }
    port {
      port      = 80
      node_port = 30001
    }
    type = "LoadBalancer"
  }
}

#K8s Persistent Volume Claim create
resource "kubernetes_persistent_volume_claim" "kubepvc" {
  metadata {
    name = "wordpress-pv-claim"
    labels = {
      "app" = "wordpress"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

#K8s Deployment create with the password parameter managed on the Secrets Manager
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      "app" = "wordpress"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        "app"  = "wordpress"
        "tier" = "frontend"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          "app"  = "wordpress"
          "tier" = "frontend"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress"
          env {
            name  = "WORDPRESS_DB_NAME"
            value = var.db_name
          }
          env {
            name  = "WORDPRESS_DB_HOST"
            value = var.db_host
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = var.db_username
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = var.db_password
                key  = "password"
              }
            }
          }
          port {
            container_port = 80
            name           = "wordpress"
          }
          volume_mount {
            name       = "wordpress-ps"
            mount_path = "/var/www/html"
          }
        }
        volume {
          name = "wordpress-ps"
          persistent_volume_claim {
            claim_name = "wordpress-pv-claim"
          }
        }
      }
    }
  }
}