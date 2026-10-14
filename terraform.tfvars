
aws_region          = "us-east-1"
project_name        = "ecs-app"
ecr_repository_name = "my-ecs-app"
cluster_name        = "ecs-ec2-cluster"
ec2_instance_type   = "t3.small"
ec2_instance_count  = 2
task_family         = "my-ecs-task"
container_name      = "my-ecs-container"
service_name        = "my-ecs-service"
desired_count       = 2