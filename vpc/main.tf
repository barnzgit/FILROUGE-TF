### Creation du vpc 
resource "aws_vpc" "mon_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.nom_vpc
  }
}

### Creation des 2 sous-réseaux publics

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

### Creation des 2 sous-réseaux privés pour le cluster EKS
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


# INTERNET GATEWAY
resource "aws_internet_gateway" "mon_igw" {
  vpc_id = "${aws_vpc.mon_vpc.id}"

  tags = {
    Name        = var.nom_vpc
  }

  depends_on = [aws_vpc.mon_vpc]
}

# TABLE DE ROUTAGE PUBLIC
resource "aws_route_table" "rtb_public" {

  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-public"
  }

  depends_on = [aws_vpc.mon_vpc]
}

# Création route vers passerelle Internet
resource "aws_route" "route_igw" {
  route_table_id         = "${aws_route_table.rtb_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mon_igw.id}"

  depends_on = [aws_internet_gateway.mon_igw]
}

# Ajout sous-réseau public-a à la table de routage
resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [aws_route_table.rtb_public]
}

# Ajout sous-réseau public-b à la table de routage
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [aws_route_table.rtb_public]
}

## NAT sous-réseau public a et une ip élastique
resource "aws_eip" "eip_public_a" {
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = "${aws_eip.eip_public_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  tags = {
    Name = "${var.nom_vpc}-${var.az_a}"
  }
}

## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appa" {

  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-private-3a"
  }

}

#Route vers la passerelle nat
resource "aws_route" "route_appa_nat" {
  route_table_id         = "${aws_route_table.rtb_appa.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_a.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = "${aws_subnet.private_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_appa.id}"
}


## NAT et routes pour le sous-réseau b ip élastique pour la passerelle b
resource "aws_eip" "eip_public_b" {
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = "${aws_eip.eip_public_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"

  tags = {
    Name = "${var.nom_vpc}-${var.az_b}"
  }
}

resource "aws_route_table" "rtb_appb" {

  vpc_id = "${aws_vpc.mon_vpc.id}"
  tags = {
    Name        = "${var.nom_vpc}-private-3b"
  }

}

resource "aws_route" "route_appb_nat" {
  route_table_id         = "${aws_route_table.rtb_appb.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_b.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = "${aws_subnet.private_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_appb.id}"
}