
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_iam_role" "instance_role" {
  name = "${var.project_name}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "instance_policy" {
  role = aws_iam_role.instance_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project_name}-ecs-instance-profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_security_group" "ecs" {
  name   = "${var.project_name}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description = "SSH - restrict to trusted IPs in production"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "ecs" {
  count         = var.ec2_instance_count
  ami           = data.aws_ami.ecs.id
  instance_type = var.ec2_instance_type

  subnet_id = var.subnet_ids[count.index]

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  vpc_security_group_ids = [
    aws_security_group.ecs.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
  EOF

  tags = {
    Name = "${var.project_name}-ecs-instance-${count.index + 1}"
  }

  depends_on = [
    aws_iam_role_policy_attachment.instance_policy
  ]
}