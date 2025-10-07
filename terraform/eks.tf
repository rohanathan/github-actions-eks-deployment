module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name                   = "eks-demo-cluster"
  cluster_version                = "1.30"
  cluster_endpoint_public_access = true
  enable_irsa                    = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    default = {
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  access_entries = {
    admin = {
      principal_arn = "arn:aws:iam::897545368009:user/terraform-org-admin"
      policy_associations = [{
        policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = { type = "cluster" }
      }]
    }

    gha_role = {
      # reference the role you create above, so TF knows the order
      principal_arn = aws_iam_role.gha_deploy_role.arn
      policy_associations = [{
        policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = { type = "cluster" }
      }]
    }
  }

  tags = { Project = "eks-demo" }

  # make creation order explicit
  depends_on = [aws_iam_role.gha_deploy_role]
}
