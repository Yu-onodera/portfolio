# -------------------------------------------------------------
# Elastic IP の作成（NAT Gateway用）
# VPC向けにElastic IPを割り当てる（domain = "vpc" を必ず指定）
# Elastic IP for NAT Gateway in ap-northeast-1a(冗長構成)
# -------------------------------------------------------------
resource "aws_eip" "portfolio_nat_eip_1a" {
  domain = "vpc"         # VPC向けEIPにする設定(必須)

  tags = {
    Name = "portfolio-nat-eip-1a"
  }
}

# Elastic IP for NAT Gateway in ap-northeast-1c(冗長構成)
resource "aws_eip" "portfolio_nat_eip_1c" {
  domain = "vpc"         # VPC向けEIPにする設定(必須)

  tags = {
    Name = "portfolio-nat-eip-1c"
  }
}

# -------------------------------------------------------------
# NAT Gateway の作成
# Public Subnetに設置し、Elastic IP を割り当てる
# Private Subnetからインターネットへ出るための中継役
# NAT Gateway in ap-northeast-1a(冗長構成)
# -------------------------------------------------------------
resource "aws_nat_gateway" "portfolio_nat_gw_1a" {
  allocation_id = aws_eip.portfolio_nat_eip_1a.id                 # 割り当てるEIPのID
  subnet_id     = aws_subnet.portfolio_public_subnet_1a.id        #NAT Gatewayを配置するPublic Subnet

  tags = {
    Name = "portfolio-nat-gw-1a"
  }

  depends_on = [aws_internet_gateway.portfolio_igw]               # IGW作成後にNAT GWを作るよう制御
}

# NAT Gateway in ap-northeast-1c(冗長構成)
resource "aws_nat_gateway" "portfolio_nat_gw_1c" {
  allocation_id = aws_eip.portfolio_nat_eip_1c.id                 # 割り当てるEIPのID
  subnet_id     = aws_subnet.portfolio_public_subnet_1c.id        #NAT Gatewayを配置するPublic Subnet

  tags = {
    Name = "portfolio-nat-gw-1c"
  }

  depends_on = [aws_internet_gateway.portfolio_igw]               # IGW作成後にNAT GWを作るよう制御
}