output "wordpress_deployment_name" {
  value = kubernetes_deployment.wordpress.metadata[0].name
}