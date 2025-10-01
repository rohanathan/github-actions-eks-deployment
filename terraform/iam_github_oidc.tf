# --- Adjust these two to your repo ---
variable "github_owner" { 
    type = string 
    default = "rohanathan" 
    }
variable "github_repo"  {
    type = string 
    default = "github-actions-eks-deployment" 
    }

# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # GitHub's well-known thumbprint (as of 2024/2025)
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Trust policy: allow ONLY your repo to assume the role via OIDC
data "aws_iam_policy_document" "gha_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_owner}/${var.github_repo}:*"]
    }
  }
}

# Permissions -> ECR push/pull + EKS describe
data "aws_iam_policy_document" "gha_policy_doc" {
  statement {
    sid     = "EcrPushPull"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchGetImage",
      "ecr:PutImage"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "EksDescribe"
    actions = ["eks:DescribeCluster"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "gha_policy" {
  name   = "gha-ecr-eks-deploy"
  policy = data.aws_iam_policy_document.gha_policy_doc.json
}

resource "aws_iam_role" "gha_deploy_role" {
  name               = "gha-eks-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.gha_trust.json
}

resource "aws_iam_role_policy_attachment" "gha_attach" {
  role       = aws_iam_role.gha_deploy_role.name
  policy_arn = aws_iam_policy.gha_policy.arn
}

