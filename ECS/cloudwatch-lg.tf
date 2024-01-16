resource "aws_cloudwatch_log_group" "ecs_services_log_group" {
  name = "/aws/ecs/stars-${lower(var.environment)}"
  retention_in_days = 90
  tags = local.tags
}