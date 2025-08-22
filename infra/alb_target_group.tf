resource "aws_lb_target_group" "web_admin_tg" {
  name     = "web-admin-tg"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.main.id

  health_check {
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    port                = "traffic-port"
  }
}
