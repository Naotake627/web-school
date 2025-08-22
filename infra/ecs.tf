resource "aws_ecs_cluster" "web_admin_cluster" {
  name = "${var.project_name}-${var.environment}-cluster"
}

