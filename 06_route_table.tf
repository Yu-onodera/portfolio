# -------------------------------------------------------------
# [WEB層] ルートテーブルの作成（Public Subnet 用）
# Public Subnet からインターネットへ通信できるようにするための設定
# -------------------------------------------------------------
resource "aws_route_table" "portfolio_rtb_public" {
  vpc_id = aws_vpc.portfolio_vpc.id        # 関連付けるVPCのID

  tags = {
    Name = "portfolio-rtb-public"
  }
}

# -------------------------------------------------------------
# ルートの追加：0.0.0.0/0 宛の通信を IGW にルーティング
# インターネットアクセスのためのデフォルトルート
# -------------------------------------------------------------
resource "aws_route" "portfolio_public_internet_access" {
  route_table_id         = aws_route_table.portfolio_rtb_public.id        # 対象のルートテーブル
  destination_cidr_block = "0.0.0.0/0"        # すべてのIPv4通信
  gateway_id             = aws_internet_gateway.portfolio_igw.id       # インターネットゲートウェイ
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_public_subnet_1a を portfolio_rtb_public に紐付け
# これにより portfolio_public_subnet_1a は IGW 経由で通信可能となる
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_public_subnet_1a_assoc" {
  subnet_id      = aws_subnet.portfolio_public_subnet_1a.id
  route_table_id = aws_route_table.portfolio_rtb_public.id
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_public_subnet_1c を portfolio_rtb_public に紐付け
# 可用性ゾーンをまたいだ冗長構成に対応（1a/1c 両方で通信可能にする）
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_public_subnet_1c_assoc" {
  subnet_id      = aws_subnet.portfolio_public_subnet_1c.id
  route_table_id = aws_route_table.portfolio_rtb_public.id
}

# -------------------------------------------------------------
# [APP層] ルートテーブル（1a 用）
# Private Subnet (1a) → NAT Gateway (1a) へルーティング
# -------------------------------------------------------------
resource "aws_route_table" "portfolio_rtb_private_app_1a" {
  vpc_id = aws_vpc.portfolio_vpc.id        # 関連付けるVPCのID

  tags = {
    Name = "portfolio-rtb-private-app-1a"
  }
}

# -------------------------------------------------------------
# ルート追加: すべての通信を NAT Gateway (1a) にルーティング
# -------------------------------------------------------------
resource "aws_route" "portfolio_app_1a_to_natgw" {
  route_table_id         = aws_route_table.portfolio_rtb_private_app_1a.id        # 対象のルートテーブル
  destination_cidr_block = "0.0.0.0/0"        # すべてのIPv4通信
  nat_gateway_id         = aws_nat_gateway.portfolio_nat_gw_1a.id       # インターネットゲートウェイ
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_private_subnet_1a_app を portfolio_rtb_private_app_1a に紐付け
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_private_subnet_1a_app_assoc" {
  subnet_id      = aws_subnet.portfolio_private_subnet_1a_app.id
  route_table_id = aws_route_table.portfolio_rtb_private_app_1a.id
}

# -------------------------------------------------------------
# [APP層] ルートテーブル（1c 用）
# Private Subnet (1c) → NAT Gateway (1c) へルーティング
# -------------------------------------------------------------
resource "aws_route_table" "portfolio_rtb_private_app_1c" {
  vpc_id = aws_vpc.portfolio_vpc.id        # 関連付けるVPCのID

  tags = {
    Name = "portfolio-rtb-private-app-1c"
  }
}

# -------------------------------------------------------------
# ルート追加: すべての通信を NAT Gateway (1c) にルーティング
# -------------------------------------------------------------
resource "aws_route" "portfolio_app_1c_to_natgw" {
  route_table_id         = aws_route_table.portfolio_rtb_private_app_1c.id        # 対象のルートテーブル
  destination_cidr_block = "0.0.0.0/0"        # すべてのIPv4通信
  nat_gateway_id         = aws_nat_gateway.portfolio_nat_gw_1c.id       # インターネットゲートウェイ
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_private_subnet_1c_app を portfolio_rtb_private_app_1c に紐付け
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_private_subnet_1c_app_assoc" {
  subnet_id      = aws_subnet.portfolio_private_subnet_1c_app.id
  route_table_id = aws_route_table.portfolio_rtb_private_app_1c.id
}

# -------------------------------------------------------------
# [DB層] 共通ルートテーブルの作成
# DBサブネットは外部との通信を行わない前提の閉域構成
# -------------------------------------------------------------
resource "aws_route_table" "portfolio_rtb_private_db" {
  vpc_id = aws_vpc.portfolio_vpc.id        # 関連付けるVPCのID

  tags = {
    Name = "portfolio-rtb-private-db"
  }
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_private_subnet_1a_db を portfolio_rtb_private_db に紐付け
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_private_subnet_1a_db_assoc" {
  subnet_id      = aws_subnet.portfolio_private_subnet_1a_db.id
  route_table_id = aws_route_table.portfolio_rtb_private_db.id
}

# -------------------------------------------------------------
# サブネット関連付け：portfolio_private_subnet_1c_db を portfolio_rtb_private_db に紐付け
# -------------------------------------------------------------
resource "aws_route_table_association" "portfolio_private_subnet_1c_db_assoc" {
  subnet_id      = aws_subnet.portfolio_private_subnet_1c_db.id
  route_table_id = aws_route_table.portfolio_rtb_private_db.id
}