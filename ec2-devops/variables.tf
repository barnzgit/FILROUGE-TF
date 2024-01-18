variable "projet" {
  description = "Nom du projet"
  default     = "filrouge"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-05094a48a33a27ecb"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-0b1c50b7794b140ee"
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