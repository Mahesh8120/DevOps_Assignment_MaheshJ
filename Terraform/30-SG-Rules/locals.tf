locals {
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_sg_id.value
    eks_node_sg_id = data.aws_ssm_parameter.eks_node_sg_id.value
    

}