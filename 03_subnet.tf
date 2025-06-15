# -------------------------------------------------------------
# [WEB層] パブリックサブネット（1a 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_public_subnet_1a" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-public-subnet-1a"
  }
}

# -------------------------------------------------------------
# [WEB層] パブリックサブネット（1c 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_public_subnet_1c" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-public-subnet-1c"
  }
}

# -------------------------------------------------------------
# [APP層] プライベートサブネット（1a 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_private_subnet_1a_app" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-private-subnet-1a-app"
  }
}

# -------------------------------------------------------------
# [APP層] プライベートサブネット（1c 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_private_subnet_1c_app" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.14.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-private-subnet-1c-app"
  }
}

# -------------------------------------------------------------
# [DB層] プライベートサブネット（1a 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_private_subnet_1a_db" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.22.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-private-subnet-1a-db"
  }
}

# -------------------------------------------------------------
# [DB層] プライベートサブネット（1c 用）
# -------------------------------------------------------------
resource "aws_subnet" "portfolio_private_subnet_1c_db" {
  vpc_id            = aws_vpc.portfolio_vpc.id 
  cidr_block        = "10.0.24.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false       # 起動時に自動パブリックIPを自動付与しない

  tags = {
    Name = "portfolio-private-subnet-1c-db"
  }
}