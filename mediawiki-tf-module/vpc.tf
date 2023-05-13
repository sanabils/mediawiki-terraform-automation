resource "aws_vpc" "mediawikiVpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.mediawikiVpc.id
  count                   = length(var.subnets_cidr_public)
  availability_zone       = element(var.azs_public, count.index)
  cidr_block              = element(var.subnets_cidr_public, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "mediawikiVpcInternetGateway" {
  vpc_id = aws_vpc.mediawikiVpc.id
  tags = {
    "Name" = "mediawikiVpcGateway"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "mediawikiVpcElasticIP"
  }
}

resource "aws_nat_gateway" "mediawikiVpcNatGateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicSubnet[0].id
  tags = {
    "Name" = "mediawikiNATGateway"
  }
}

resource "aws_default_route_table" "publicRouteTable" {
  default_route_table_id = aws_vpc.mediawikiVpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mediawikiVpcInternetGateway.id
  }
  tags = {
    "Name" = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "publicRouteTableAssociation" {
  count          = length(var.subnets_cidr_public)
  subnet_id      = element(aws_subnet.publicSubnet.*.id, count.index)
  route_table_id = aws_vpc.mediawikiVpc.default_route_table_id
}
