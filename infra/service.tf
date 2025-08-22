resource "aws_ecs_service" "web_admin" {
  name            = "web-admin-service"
  cluster         = aws_ecs_cluster.web_admin_cluster.id
  task_definition = aws_ecs_task_definition.web_admin.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  enable_execute_command = true # ✅ これを追加

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.web_admin_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_admin.arn
    container_name   = "web-admin"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.web_admin]
}
