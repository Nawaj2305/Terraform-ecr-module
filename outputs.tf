
output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL for Docker image pushes"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}