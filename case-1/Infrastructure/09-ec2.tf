resource "aws_instance" "bastion" {
  ami                         = "ami-0220d79f3f480ecf5"
  instance_type               = "t3.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("userdata.sh")

  tags = {
    Name = "Jenkins"
  }
}