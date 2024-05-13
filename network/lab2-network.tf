# ===== VPC =====
resource "aws_vpc" "lab1-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tag}-vpc"
  }
}

# ===== subnets creation =====
resource "aws_subnet" "subnets" {
  count = length(var.subnets)

  vpc_id     = aws_vpc.lab1-vpc.id
  cidr_block = var.subnets[count.index].cidr

  tags = {
    Name = "${var.tag}-${var.subnets[count.index].name}"
  }
}

# ===== Gateway =====
resource "aws_internet_gateway" "lab1-gw" {
  vpc_id = aws_vpc.lab1-vpc.id

  tags = {
    Name = "${var.tag}-gw"
  }
}

# ===== elastic IP for NAT =====
resource "aws_eip" "eip-Natlab1" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.lab1-gw]
}

# ===== NAT =====
resource "aws_nat_gateway" "lab1-nat" {
  allocation_id = aws_eip.eip-Natlab1.id
  subnet_id     = aws_subnet.subnets[0].id

}

# ===== public route table =====
resource "aws_route_table" "pub-table" {
  vpc_id = aws_vpc.lab1-vpc.id

  route {
    cidr_block = var.cidr_zero
    gateway_id = aws_internet_gateway.lab1-gw.id
  }

  tags = {
    Name = "${var.tag}-pubTable-1"
  }
}
# ===== private route table =====
resource "aws_route_table" "private-table" {
  vpc_id = aws_vpc.lab1-vpc.id

  route {
    cidr_block = var.cidr_zero
    gateway_id = aws_nat_gateway.lab1-nat.id
  }
  tags = {
    Name = "${var.tag}-privateTable-1"
  }
}

# ===== associate routes with subnets =====
resource "aws_route_table_association" "subnet_asso" {
  for_each = { for s, subnet in var.subnets : s => subnet }

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = each.value.type == "public" ? aws_route_table.pub-table.id : aws_route_table.private-table.id
}
