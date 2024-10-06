resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.name)
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = format("%s-%s", var.name, each.key)
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-igw", var.name)
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-public-rtb", var.name)
  }
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
