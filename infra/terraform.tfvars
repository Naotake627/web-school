project_name       = "hotel-de-work"
environment        = "production"
vpc_cidr_block     = "10.0.0.0/16"
region             = "ap-northeast-1"
ecr_repository_url = "572902360514.dkr.ecr.ap-northeast-1.amazonaws.com/hotel-de-work-web-admin"
container_port     = 3000
desired_count      = 1
vpc_id             = "vpc-8d4751ea"

# terraform.tfvars からこれを削除
#subnet_ids = [
#  "subnet-8e3dedc6",
#  "subnet-55393b0e",
#  "subnet-780dd653"
#]
