variable "ec2_nom" {
  description = "Nom de l'instance"
  default     = "filrouge-devops"
}

variable "ec2_key" {
  description = "Nom de la key pair"
  default     =  "aws-devops"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-08a1390e2dd6d9325"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-0404fdf890e384482"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "script install"
  type        = string
  default     = "devops-install.sh"
}