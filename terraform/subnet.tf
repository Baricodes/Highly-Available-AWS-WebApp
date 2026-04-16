# ------------------------------------------------------------------------------
# Availability zones (locals)
# ------------------------------------------------------------------------------

locals {
  az1 = "us-east-1b"
  az2 = "us-east-1c"
}

# ------------------------------------------------------------------------------
# Public subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = local.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.webapp_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = local.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

# ------------------------------------------------------------------------------
# Private application subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = local.az1

  tags = {
    Name = "private-app-a"
  }
}

resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = local.az2

  tags = {
    Name = "private-app-b"
  }
}

# ------------------------------------------------------------------------------
# Private database subnets
# ------------------------------------------------------------------------------

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = local.az1

  tags = {
    Name = "private-db-a"
  }
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.webapp_vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = local.az2

  tags = {
    Name = "private-db-b"
  }
}
