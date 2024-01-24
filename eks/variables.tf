variable "projet" {
  description = "Nom du projet"
  default     = "filrouge"
}

variable "vpc_id" {
  description = "ID du vpc"
  default     = "vpc-08a1390e2dd6d9325"
}

variable "public_subnet_a" {
    description = "subnet public az-a"
    default = "subnet-0404fdf890e384482"
}

variable "public_subnet_b" {
    description = "subnet public az-b"
    default = "subnet-068a3c4550b6df3d6"
}

variable "private_subnet_a" {
    description = "subnet prive az-a"
    default = "subnet-099d1393e24d3b680"
}

variable "private_subnet_b" {
    description = "subnet prive az-b"
    default = "subnet-03efe11853184e88a"
}