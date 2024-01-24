
# SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.ec2_nom}-sg"
  description = "Security Group pour ${var.ec2_nom}"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

# EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name = var.ec2_nom
  instance_type               = var.instance_type
  key_name                    = var.ec2_key
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = file(var.user_data)
  
}