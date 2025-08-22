resource "aws_ecr_repository" "hotel_de_work" {
  name                 = "hotel-de-work"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository_policy" "allow_push_by_admin" {
  repository = aws_ecr_repository.hotel_de_work.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid    = "AllowPushByHotelDeWorkAdmin",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::572902360514:user/hotel-de-work-admin"
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "allow_push" {
  user       = "hotel-de-work-admin"
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}
