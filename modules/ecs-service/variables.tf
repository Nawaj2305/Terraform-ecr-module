
variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "task_family" {
  type = string
}

variable "container_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "listener_arn" {
  type = string
}