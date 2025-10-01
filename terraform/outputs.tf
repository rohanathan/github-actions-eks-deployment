output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "gha_deploy_role_arn" {
  value = aws_iam_role.gha_deploy_role.arn
}
