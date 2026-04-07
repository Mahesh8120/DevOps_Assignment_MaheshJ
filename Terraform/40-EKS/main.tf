module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # module version

  name               = var.project_name
  kubernetes_version = var.eks_version

  addons = {
    coredns = {}

    eks-pod-identity-agent = {
      before_compute = true
    }

    kube-proxy = {}

    vpc-cni = {
      before_compute = true
    }

    metrics-server = {}
  }

  endpoint_public_access = false
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_node_security_group = false
  create_security_group      = false

  node_security_group_id = local.eks_node_sg_id
  security_group_id      = local.eks_control_plane_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    blue = {
      create             = var.enable_blue
      ami_type           = "AL2023_x86_64_STANDARD"
      kubernetes_version = var.eks_nodegroup_blue_version
      instance_types     = ["m6a.large"]

      iam_role_additional_policies = {
        amazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        amazonEBS = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      # autoscaling
      min_size     = 2
      max_size     = 10
      desired_size = 2

      labels = {
        nodegroup = "particle41"
      }
    }
  }

  tags = merge(
    local.common_tags,
    
  )
}