# Configure the AWS Provider

variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}


variable "ecr_repository_name" {
  default = "my-app-repo"
}

variable "cluster_name" {
  default = "my-ecs-cluster"
}

variable "task_family" {
  default = "my-app-task"
}

# Creating thr repo for storing the docker image

resource "aws_ecr_repository" "main" {
  name = var.ecr_repository_name
}

# Creating the cluster for the deployment of the application

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# Define the task 

resource "aws_ecs_task_definition" "main" {
  family                = var.task_family
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "1000"
  memory                = "1024"

  container_definitions = jsonencode([
    {
      name      = "my-app-container",
      image     = "${aws_ecr_repository.main.repository_url}:latest",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ],
      essential = true
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0de5362f433effcf1"] 
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.main]
}

# Output the ECR Repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}
