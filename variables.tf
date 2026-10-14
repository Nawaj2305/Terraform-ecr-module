
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "ecs-app"
}

variable "ecr_repository_name" {
  type    = string
  default = "my-ecs-app"
}

variable "cluster_name" {
  type    = string
  default = "ecs-ec2-cluster"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.small"
}

variable "ec2_instance_count" {
  type    = number
  default = 2

  validation {
    condition     = var.ec2_instance_count >= 2 && var.ec2_instance_count <= 2
    error_message = "This configuration uses exactly two public subnets and supports two ECS EC2 instances."
  }
}

variable "task_family" {
  type    = string
  default = "my-ecs-task"
}

variable "container_name" {
  type    = string
  default = "my-ecs-container"
}

variable "service_name" {
  type    = string
  default = "my-ecs-service"
}

variable "desired_count" {
  type    = number
  default = 2
}