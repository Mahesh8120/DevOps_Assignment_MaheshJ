resource "aws_instance" "bastion" {
    ami = ami-0220d79f3f480ecf5
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    subnet_id = module.vpc.public_subnets
    
    root_block_device {
        volume_size = 50
        volume_type = "gp3" # or "gp2", depending on your preference
    }

    user_data = file("userdata.sh")
    
    tags = {
        Name = Jenkins
    } 
    
    }