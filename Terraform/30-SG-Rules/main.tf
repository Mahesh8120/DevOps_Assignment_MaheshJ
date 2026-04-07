resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id
  cidr_blocks = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  security_group_id = local.bastion_sg_id

  from_port = 0
  to_port   = 0
  protocol  = "-1"   # ALL protocols

  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  security_group_id = local.eks_control_plane_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

resource "aws_security_group_rule" "eks_node_bastion" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  source_security_group_id = local.bastion_sg_id
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

# EKS nodes can accept all kind of traffic from EKS control plane
resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  source_security_group_id = local.eks_control_plane_sg_id
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}

resource "aws_security_group_rule" "eks_control_plane_eks_node" {
  type              = "ingress"
  security_group_id = local.eks_control_plane_sg_id
  source_security_group_id = local.eks_node_sg_id
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}

# Mandatory for pod to pod communication. because pods can be in any node in VPC CIDR
resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  security_group_id = local.eks_node_sg_id
  cidr_blocks = ["10.0.0.0/16"]
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}