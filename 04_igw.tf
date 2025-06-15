# -------------------------------------------------------------
# インターネットゲートウェイ
# -------------------------------------------------------------
resource "aws_internet_gateway" "portfolio_igw" {
  vpc_id = aws_vpc.portfolio_vpc.id        # 紐づけるのVPCのID

  tags = {
    Name = "portfolio-igw"
  }
}