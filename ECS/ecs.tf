  locals {
    webportal_name = "webportal"
    product_name = "product"
    identity_name = "identity"
    studies_name = "studies"
  }

################################# ECS CLUSTER ##########################################
########################################################################################

resource "aws_ecs_cluster" "stars-cluster"{
  name = "${lower(var.application)}-${lower(var.environment)}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = local.tags
}

############################### TASK DEFINITION ######################################
######################################################################################

resource "aws_ecs_task_definition" "ecs_webportal_task" {

  family                   = "${lower(var.application)}-${local.webportal_name}"
  execution_role_arn       = "${var.task_exec_role}"              # required, copy form IAM page, Role button
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "${var.task_exec_role}"
  tags                     = local.tags
  container_definitions    = jsonencode([{
    name         = "${lower(var.application)}-${local.webportal_name}"
    image        = "${module.ecr["${var.repositories["webportal"].name}"].repository_url}:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        awslogs-group         = "/ecs/${lower(var.application)}-${lower(var.environment)}"
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "${local.webportal_name}"
      }
    }
    essential    = true
    networkMode  = "awsvpc"
    cpu          = 256
    memory       = 512
    portMappings = [{
      portocol      = "tcp"
      containerPort = 80  # container port
      hostPort      = 80  # web request port
    }]
    environment = [
      {
          name = "EBApplicationConfiguration"
          value = "{\"AwsConfiguration\": {\"SecretName\": \"${lower(var.application)}/${lower(var.environment)}/${local.webportal_name}\",\"Region\": \"eu-central-1\"}}"
      },
      {
          "name": "ASPNETCORE_ENVIRONMENT",
          "value": "${lower(var.environment)}"
      }
    ]
  }])

}

# ################################ ECS SERVICE #########################################
# ######################################################################################

resource "aws_ecs_service" "ecs_webportal_service" {

  task_definition = aws_ecs_task_definition.ecs_webportal_task.arn
  name            = "${lower(var.application)}-${local.webportal_name}-service"
  cluster         = aws_ecs_cluster.stars-cluster.id
  desired_count   = 1
  propagate_tags  = "SERVICE"
  launch_type     = "FARGATE"
  tags            = local.tags

  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.ecs_subnets
    assign_public_ip = false         
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[3]
    container_name   = "${lower(var.application)}-${local.webportal_name}"
    container_port   = 80
  }
}

############################### TASK DEFINITION ######################################
######################################################################################

resource "aws_ecs_task_definition" "ecs_product_task" {

  family                   = "${lower(var.application)}-${local.product_name}"
  execution_role_arn       = "${var.task_exec_role}"              # required, copy form IAM page, Role button
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "${var.task_exec_role}"
  tags                     = local.tags
  container_definitions    = jsonencode([{
    name         = "${lower(var.application)}-${local.product_name}"
    image        = "${module.ecr["${var.repositories["product"].name}"].repository_url}:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        awslogs-group         = "/ecs/${lower(var.application)}-${lower(var.environment)}"
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "${local.product_name}"
      }
    }
    essential    = true
    networkMode  = "awsvpc"
    cpu          = 256
    memory       = 512
    portMappings = [{
      portocol      = "tcp"
      containerPort = 80  # container port
      hostPort      = 80  # web request port
    }]
    environment = [
      {
          name = "EBApplicationConfiguration"
          value = "{\"AwsConfiguration\": {\"SecretName\": \"${lower(var.application)}/${lower(var.environment)}/${local.product_name}\",\"Region\": \"eu-central-1\"}}"
      },
      {
          "name": "ASPNETCORE_ENVIRONMENT",
          "value": "${lower(var.environment)}"
      }
    ]
  }])

}

# ################################ ECS SERVICE #########################################
# ######################################################################################

resource "aws_ecs_service" "ecs_product_service" {

  task_definition = aws_ecs_task_definition.ecs_product_task.arn
  name            = "${lower(var.application)}-${local.product_name}-service"
  cluster         = aws_ecs_cluster.stars-cluster.id
  desired_count   = 1
  propagate_tags  = "SERVICE"
  launch_type     = "FARGATE"
  tags            = local.tags

  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.ecs_subnets
    assign_public_ip = false         
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[3]
    container_name   = "${lower(var.application)}-${local.product_name}"
    container_port   = 80
  }
}

############################### TASK DEFINITION ######################################
######################################################################################

resource "aws_ecs_task_definition" "ecs_studies_task" {

  family                   = "${lower(var.application)}-${local.studies_name}"
  execution_role_arn       = "${var.task_exec_role}"              # required, copy form IAM page, Role button
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "${var.task_exec_role}"
  tags                     = local.tags
  container_definitions    = jsonencode([{
    name         = "${lower(var.application)}-${local.studies_name}"
    image        = "${module.ecr["${var.repositories["studies"].name}"].repository_url}:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        awslogs-group         = "/ecs/${lower(var.application)}-${lower(var.environment)}"
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "${local.studies_name}"
      }
    }
    essential    = true
    networkMode  = "awsvpc"
    cpu          = 256
    memory       = 512
    portMappings = [{
      portocol      = "tcp"
      containerPort = 80  # container port
      hostPort      = 80  # web request port
    }]
    environment = [
      {
          name = "EBApplicationConfiguration"
          value = "{\"AwsConfiguration\": {\"SecretName\": \"${lower(var.application)}/${lower(var.environment)}/${local.studies_name}\",\"Region\": \"eu-central-1\"}}"
      },
      {
          "name": "ASPNETCORE_ENVIRONMENT",
          "value": "${lower(var.environment)}"
      }
    ]
  }])

}

# ################################ ECS SERVICE #########################################
# ######################################################################################

resource "aws_ecs_service" "ecs_studies_service" {

  task_definition = aws_ecs_task_definition.ecs_studies_task.arn
  name            = "${lower(var.application)}-${local.studies_name}-service"
  cluster         = aws_ecs_cluster.stars-cluster.id
  desired_count   = 1
  propagate_tags  = "SERVICE"
  launch_type     = "FARGATE"
  tags            = local.tags

  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.ecs_subnets
    assign_public_ip = false         
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[3]
    container_name   = "${lower(var.application)}-${local.studies_name}"
    container_port   = 80
  }
}

############################### TASK DEFINITION ######################################
######################################################################################

resource "aws_ecs_task_definition" "ecs_identity_task" {

  family                   = "${lower(var.application)}-${local.identity_name}"
  execution_role_arn       = "${var.task_exec_role}"              # required, copy form IAM page, Role button
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "${var.task_exec_role}"
  tags                     = local.tags
  container_definitions    = jsonencode([{
    name         = "${lower(var.application)}-${local.identity_name}"
    image        = "${module.ecr["${var.repositories["identity"].name}"].repository_url}:latest"
    logConfiguration = {
      logDriver = "awslogs",
      options   = {
        awslogs-group         = "/ecs/${lower(var.application)}-${lower(var.environment)}"
        awslogs-region        = "eu-central-1"
        awslogs-stream-prefix = "${local.identity_name}"
      }
    }
    essential    = true
    networkMode  = "awsvpc"
    cpu          = 256
    memory       = 512
    portMappings = [{
      portocol      = "tcp"
      containerPort = 80  # container port
      hostPort      = 80  # web request port
    }]
    environment = [
      {
          name = "EBApplicationConfiguration"
          value = "{\"AwsConfiguration\": {\"SecretName\": \"${lower(var.application)}/${lower(var.environment)}/${local.identity_name}\",\"Region\": \"eu-central-1\"}}"
      },
      {
          "name": "ASPNETCORE_ENVIRONMENT",
          "value": "${lower(var.environment)}"
      }
    ]
  }])

}

# ################################ ECS SERVICE #########################################
# ######################################################################################

resource "aws_ecs_service" "ecs_identity_service" {

  task_definition = aws_ecs_task_definition.ecs_identity_task.arn
  name            = "${lower(var.application)}-${local.identity_name}-service"
  cluster         = aws_ecs_cluster.stars-cluster.id
  desired_count   = 1
  propagate_tags  = "SERVICE"
  launch_type     = "FARGATE"
  tags            = local.tags

  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.ecs_subnets
    assign_public_ip = false         
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arns[3]
    container_name   = "${lower(var.application)}-${local.identity_name}"
    container_port   = 80
  }
}