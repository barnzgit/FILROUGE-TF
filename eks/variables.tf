variable "projet" {
  description = "Nom du projet"
  default     = "filrouge"
}

variable "vpc_id" {
  description = "ID du vpc"
  default     = "vpc-05094a48a33a27ecb"
}

variable "public_subnet_a" {
    description = "subnet public az-a"
    default = "subnet-0b1c50b7794b140ee"
}

variable "public_subnet_b" {
    description = "subnet public az-b"
    default = "subnet-0f776b1321942137c"
}

variable "private_subnet_a" {
    description = "subnet prive az-a"
    default = "subnet-09cdf0c5b29ca517f"
}

variable "private_subnet_b" {
    description = "subnet prive az-b"
    default = "subnet-0b1c50b7794b140ee"
}