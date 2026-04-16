# ------------------------------------------------------------------------------
# Public route table (internet via IGW)
# ------------------------------------------------------------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "public-rt"
  }
}

# Default route: all traffic to the internet gateway

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.webapp_igw.id
}

# Associate public subnets with this route table

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# ------------------------------------------------------------------------------
# Private app route table — AZ A (internet via NAT in public subnet A)
# ------------------------------------------------------------------------------

resource "aws_route_table" "private_app_a_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "private-app-a-rt"
  }
}

# Default route: egress via NAT in AZ A

resource "aws_route" "private_app_a_internet" {
  route_table_id         = aws_route_table.private_app_a_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

# Associate private app subnet (AZ A)

resource "aws_route_table_association" "private_app_a" {
  subnet_id      = aws_subnet.private_app_a.id
  route_table_id = aws_route_table.private_app_a_rt.id
}

# ------------------------------------------------------------------------------
# Private app route table — AZ B (internet via NAT in public subnet B)
# ------------------------------------------------------------------------------

resource "aws_route_table" "private_app_b_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "private-app-b-rt"
  }
}

# Default route: egress via NAT in AZ B

resource "aws_route" "private_app_b_internet" {
  route_table_id         = aws_route_table.private_app_b_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

# Associate private app subnet (AZ B)

resource "aws_route_table_association" "private_app_b" {
  subnet_id      = aws_subnet.private_app_b.id
  route_table_id = aws_route_table.private_app_b_rt.id
}

# ------------------------------------------------------------------------------
# Private database route table (no default route to internet)
# ------------------------------------------------------------------------------

resource "aws_route_table" "private_db_rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "private-db-rt"
  }
}

# Associate private database subnets (local VPC routing only)

resource "aws_route_table_association" "private_db_a" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private_db_rt.id
}

resource "aws_route_table_association" "private_db_b" {
  subnet_id      = aws_subnet.private_db_b.id
  route_table_id = aws_route_table.private_db_rt.id
}
