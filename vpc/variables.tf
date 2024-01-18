variable "nom_vpc" {
  description = "Nom du vpc"
  default     = "filrouge-pvc"
}


variable "cidr_vpc" {
  description = "CIDR du VPC"
  default     = "10.0.0.0/16"
}



variable "public_subnet_a" {
  description = "CIDR du Sous-réseau  public a"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b" {
  description = "CIDR du Sous-réseau  public b"
  default     = "10.0.3.0/24"

}

variable "private_subnet_a" {
  description = "CIDR du Sous-réseau privé a"
  default     = "10.0.2.0/24"

}

variable "private_subnet_b" {
  description = "CIDR du Sous-réseau privé b"
  default     = "10.0.4.0/24"

}



variable "az_a" {
  description = "zone de disponibilité a"
  default     = "eu-west-3a"
}


variable "az_b" {
  description = "zone de disponibilité b"
  default     = "eu-west-3b"

}