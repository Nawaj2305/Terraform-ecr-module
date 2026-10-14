
variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ec2_instance_count" {
  type = number

  validation {
    condition     = var.ec2_instance_count == 2
    error_message = "This configuration requires exactly two instances."
  }
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "ssh_allowed_cidrs" {
  description = "CIDR ranges permitted to SSH to ECS instances"
  type        = list(string)
  default     = []
}