#--- VPC 

resource "aws_vpc" "mon_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.nom_vpc
  }
}

#-----------------------


#--- 2 sous-réseaux publics (1 dans chaque AZ)

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.mon_vpc.id}"
  cidr_block              = var.public_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a
  tags = {
    Name        = "${var.nom_vpc}-public-${var.az_a}"
  }
  depends_on = [aws_vpc.mon_vpc]
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.mon_vpc.id}"
  cidr_block              = var.public_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b
  tags = {
    Name        = "${var.nom_vpc}-public-${var.az_b}"
  }
  depends_on = [aws_vpc.mon_vpc]
}

#--------------------------------

#--- 2 sous-réseaux privés pour le cluster EKS

resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.mon_vpc.id
  cidr_block = var.private_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone = var.az_a
  tags = {
    Name        = "${var.nom_vpc}-private-${var.az_a}"
  }
  depends_on = [aws_vpc.mon_vpc]
}


resource "aws_subnet" "private_subnet_b" {

  vpc_id     = "${aws_vpc.mon_vpc.id}"
  cidr_block = var.private_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone = var.az_b

  tags = {
    Name        = "${var.nom_vpc}-private-${var.az_b}"
  }
  depends_on = [aws_vpc.mon_vpc]
}

#--------------------------------

#--- INTERNET GATEWAY
resource "aws_internet_gateway" "mon_igw" {
  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = var.nom_vpc
  }
  depends_on = [aws_vpc.mon_vpc]
}

#------------------------------------

#--- Table de routage publique

resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-public"
  }
  depends_on = [aws_vpc.mon_vpc]
}

#-------------------------------------

#--- Route vers IGW

resource "aws_route" "route_igw" {
  route_table_id         = "${aws_route_table.rt_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mon_igw.id}"
  depends_on = [aws_internet_gateway.mon_igw]
}

#-------------------------------------

# --- Association subnets publics a à la table de routage

resource "aws_route_table_association" "rt_asso_public_a" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
  depends_on = [aws_route_table.rt_public]
}

resource "aws_route_table_association" "rt_asso_public_b" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
  depends_on = [aws_route_table.rt_public]
}

#------------------------------------------

#### AZ A ##########################

#--- EIP pour subnet public a

resource "aws_eip" "eip_public_a" {
  domain = "vpc"
}

#-----------------------------------------

#--- NAT subnet public a

resource "aws_nat_gateway" "nat_public_a" {
  allocation_id = "${aws_eip.eip_public_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"
  tags = {
    Name = "${var.nom_vpc}-${var.az_a}"
  }
}

#-------------------------------------

#--- RT pour subnet prive a
resource "aws_route_table" "rt_private_a" {
  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-private-3a"
  }
}

#-----------------------------------

#--- Route subnet prive a vers NAT GW

resource "aws_route" "r_private_a_nat" {
  route_table_id         = "${aws_route_table.rt_private_a.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_public_a.id}"
}

#---------------------------------

#--- Association subnet prive a à la RT

resource "aws_route_table_association" "rt_asso_brivate_a" {
  subnet_id      = "${aws_subnet.private_subnet_a.id}"
  route_table_id = "${aws_route_table.rt_private_a.id}"
}

#---------------------------------------

### AZ B ##############

#--- EIP pour subnet public b

resource "aws_eip" "eip_public_b" {
  domain = "vpc"
}

#-----------------------------------------

#--- NAT subnet public b

resource "aws_nat_gateway" "nat_public_b" {
  allocation_id = "${aws_eip.eip_public_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"
  tags = {
    Name = "${var.nom_vpc}-${var.az_b}"
  }
}

#-------------------------------------

#--- RT pour subnet prive b

resource "aws_route_table" "rt_private_b" {
  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-private-3b"
  }
}

#-------------------------------------

#--- Route subnet prive b vers NAT GW

resource "aws_route" "r_private_b_nat" {
  route_table_id         = "${aws_route_table.rt_private_b.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_public_b.id}"
}

#-------------------------------------

#--- Association subnet prive b à la RT

resource "aws_route_table_association" "rt_asso_private_b" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.rt_private_b.id}"
}