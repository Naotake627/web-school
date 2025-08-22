resource "aws_ecs_task_definition" "web_admin" {
  family                   = "hotel-de-work-web-admin"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  # ✅ Execute Commandを有効化（必要に応じてコメント解除）
  # enable_execute_command = true

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "web-admin",
      image     = "572902360514.dkr.ecr.ap-northeast-1.amazonaws.com/hotel-de-work-web-admin:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp"
        }
      ],
      command = ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/hotel-de-work-web-admin",
          awslogs-region        = "ap-northeast-1",
          awslogs-stream-prefix = "web-admin"
        }
      },
      environment = [
        {
          name  = "FORCE_UPDATE"
          value = "2025-07-24T13:53:00Z"
        },
        {
          name  = "SECRET_KEY_BASE"
          value = "3e3edf21418983da7cda0e24b78bea5324f548846fa03773087de30465b2aa039e21e35adf163b6c1123d4e530e8201f341be1f0fd0a3d9cadf1a2ccd27c26ab"
        },
        {
          name  = "DB_NAME"
          value = "hotelworkdb"
        },
        {
          name  = "DB_USERNAME"
          value = "admin"
        },
        {
          name  = "DB_PASSWORD"
          value = "adminpassword123"
        },
        {
          name  = "DB_HOST"
          value = "hotel-de-work-db.cqkb4g4mwq27.ap-northeast-1.rds.amazonaws.com"
        },
        {
          name  = "DB_PORT"
          value = "3306"
        },
        {
          name  = "RAILS_ENV"
          value = "production"
        }
      ]
    }
  ])
}
