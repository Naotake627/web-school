###############################
# ECSタスク実行ロール（ECS用）
###############################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ECSの基本実行ポリシー（イメージPull、Secrets参照など）
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Exec（SSMによるリモートアクセス）用の追加ポリシー
resource "aws_iam_role_policy_attachment" "ecs_exec_ssm" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

##################################
# ECR Push用カスタムポリシー
##################################
resource "aws_iam_policy" "ecr_push_policy" {
  name        = "AllowECRPushToHotelDeWork"
  description = "Allow pushing Docker images to hotel-de-work ECR repository"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        Resource = "arn:aws:ecr:ap-northeast-1:123456789012:repository/hotel-de-work"
      }
    ]
  })
}

##################################
# IAMユーザー（docker push用）
# hotel-de-work-admin への権限付与
##################################
resource "aws_iam_user_policy_attachment" "ecr_push_permission_to_user" {
  user       = "hotel-de-work-admin"
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}
