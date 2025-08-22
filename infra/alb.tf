#########################################
# ALB (Application Load Balancer) 定義
#########################################

resource "aws_lb" "web_admin" {
  name               = "hotel-de-work-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_http2 = true
  idle_timeout = 60
}

#########################################
# ターゲットグループ（ポート8080でFargateのRailsをターゲットに）
#########################################

resource "aws_lb_target_group" "web_admin" {
  name        = "web-admin-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # Fargateでは"ip"指定が必要

  lifecycle {
    prevent_destroy = true
  }

  health_check {
    path                = "/healthcheck"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  load_balancing_algorithm_type = "round_robin"
}

#########################################
# HTTP リスナー（ポート80 → Railsへフォワード）
#########################################

resource "aws_lb_listener" "web_admin" {
  load_balancer_arn = aws_lb.web_admin.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_admin.arn
  }
}

#########################################
# HTTPS リスナー（ポート443 → Railsへフォワード）
# ※ fixed_response を削除し、正しくforwardへ
#########################################

resource "aws_lb_listener" "web_admin_https" {
  load_balancer_arn = aws_lb.web_admin.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:ap-northeast-1:572902360514:certificate/406aff7f-8ab5-4c36-83c2-9826b600908a"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_admin.arn
  }
}
