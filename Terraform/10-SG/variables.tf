variable "project_name" {
    default = "particle41"
}

variable "environment" {
    default = "dev"
}



variable "sg_names" {
    default = [
        
        
        "bastion",
        
        "eks_control_plane",
        "eks_node"
    ]
}