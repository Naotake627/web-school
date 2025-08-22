resource "aws_cloudwatch_log_group" "web_admin" {
  name              = "/ecs/hotel-de-work-web-admin"
  retention_in_days = 14
}
