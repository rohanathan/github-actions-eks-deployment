output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "gha_deploy_role_arn" {
  value = aws_iam_role.gha_deploy_role.arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "cluster_name" { value = module.eks.cluster_name }
output "cluster_region" { value = "eu-west-2" }
