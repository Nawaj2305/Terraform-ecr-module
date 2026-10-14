
module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
}

module "load_balancer" {
  source = "./modules/load-balancer"

  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.public_subnet_ids
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  project_name       = var.project_name
  cluster_name       = var.cluster_name
  ec2_instance_type  = var.ec2_instance_type
  ec2_instance_count = var.ec2_instance_count
  # Add these networking references
  vpc_id                = module.networking.vpc_id
  subnet_ids         = module.networking.public_subnet_ids
  alb_security_group_id = module.load_balancer.alb_security_group_id

   # Keep empty to disable SSH access.
  ssh_allowed_cidrs = []
}

module "ecs_service" {
  source = "./modules/ecs-service"

  project_name       = var.project_name
  cluster_name       = module.ecs_cluster.cluster_name
  cluster_id         = module.ecs_cluster.cluster_id
  repository_url     = module.ecr.repository_url
  task_family        = var.task_family
  container_name     = var.container_name
  service_name       = var.service_name
  desired_count      = var.desired_count
  target_group_arn   = module.load_balancer.target_group_arn
  listener_arn       = module.load_balancer.listener_arn

  depends_on = [
    module.ecs_cluster,
    module.ecr,
    module.load_balancer
  ]
}