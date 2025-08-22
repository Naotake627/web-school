# ============================
# ALB用のセキュリティグループ
# ============================

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP access to ALB" # ✅ 差分ゼロにするため、元の文言に戻す
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =================================
# ECSタスク（web-admin）用セキュリティグループ
# =================================

resource "aws_security_group" "web_admin_sg" {
  name        = "web-admin-sg"
  description = "Allow traffic from ALB to ECS tasks" # ✅ 元の文言に戻す
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# =================================
# RDS（MySQL）用セキュリティグループ
# =================================
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS MySQL access"
  vpc_id      = aws_vpc.main.id

  # RDSから外部への通信（例：DNS解決や時刻同期など）は全許可
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # インバウンドは下で `aws_security_group_rule` として別定義
}
# ===============================
# Allow ECS Tasks to connect to RDS
# ===============================
resource "aws_security_group_rule" "allow_web_admin_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.web_admin_sg.id
  description              = "Allow web-admin ECS tasks to access RDS MySQL"
}
