# ------------------------------------------------------------------------------
# NAT gateway elastic IPs
# ------------------------------------------------------------------------------

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "nat-a-eip"
  }

  depends_on = [aws_internet_gateway.webapp_igw]
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "nat-b-eip"
  }

  depends_on = [aws_internet_gateway.webapp_igw]
}

# ------------------------------------------------------------------------------
# NAT gateways (one per public subnet / AZ)
# ------------------------------------------------------------------------------

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "nat-a"
  }

  depends_on = [aws_internet_gateway.webapp_igw]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "nat-b"
  }

  depends_on = [aws_internet_gateway.webapp_igw]
}
