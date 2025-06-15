# -------------------------------------------------------------
# セキュリティグループの作成：ALB用
# 外部からのHTTP/HTTPSアクセスを許可
# -------------------------------------------------------------
resource "aws_security_group" "portfolio_alb_sg" {
  name        = "portfolio-alb-sg"
  description = "Allow HTTP and HTTPS from the internet"
  vpc_id      = aws_vpc.portfolio_vpc.id

  # -------------------------------------------------------------
  # インバウンドルール：HTTP (TCP 80)
  # -------------------------------------------------------------
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]       # 全許可
  }

  # -------------------------------------------------------------
  # インバウンドルール：HTTPS (TCP 443)
  # -------------------------------------------------------------
  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]       # 全許可
  }

  # -------------------------------------------------------------
  # アウトバウンドルール：全トラフィックを許可（デフォルト設定）
  # -------------------------------------------------------------
  egress {
    from_port   = 0       # 全ポート
    to_port     = 0       # 全ポート
    protocol    = "-1"        # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"]       # 送信先は全世界
  }

  tags = {
    Name = "portfolio-alb-sg"
  }
}

# -------------------------------------------------------------
# セキュリティグループの作成：EC2用
# ALBからのHTTPアクセスと、自分のIPからのSSHのみ許可
# -------------------------------------------------------------
resource "aws_security_group" "portfolio_ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP from ALB only and SSH from MyIP"
  vpc_id      = aws_vpc.portfolio_vpc.id

  # -------------------------------------------------------------
  # インバウンドルール：HTTP (TCP 80) ← ALBセキュリティグループからのみ許可
  # -------------------------------------------------------------
  ingress {
    description     = "Allow HTTP from ALB SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_alb_sg.id]
  }

  # -------------------------------------------------------------
  # アウトバウンドルール：全トラフィックを許可（デフォルト設定）
  # -------------------------------------------------------------
  egress {
    from_port   = 0       # 全ポート
    to_port     = 0       # 全ポート
    protocol    = "-1"        # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"]       # 送信先は全世界
  }

  tags = {
    Name = "portfolio-ec2-sg"
  }
}

# -------------------------------------------------------------
# セキュリティグループの作成：RDS用
# EC2からのMySQL接続のみ許可（インターネット非公開）
# -------------------------------------------------------------
resource "aws_security_group" "portfolio_rds_sg" {
  name        = "portfolio-rds-sg"
  description = "Allow MySQL access from EC2 SG only"
  vpc_id      = aws_vpc.portfolio_vpc.id

  # -------------------------------------------------------------
  # インバウンドルール：MySQL (TCP 3306) ← EC2セキュリティグループからのみ許可
  # -------------------------------------------------------------
  ingress {
    description     = "Allow MySQL from EC2 SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_ec2_sg.id]
  }
  
  # -------------------------------------------------------------
  # インバウンドルール：MySQL (TCP 3306) ← 踏み台EC2からのMySQL許可
  # -------------------------------------------------------------
  ingress {
    description     = "Allow MySQL from Bistion EC2 SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_bastion_ec2_sg.id]
  }

  # -------------------------------------------------------------
  # アウトバウンドルール：全トラフィックを許可（デフォルト設定）
  # RDSは基本的に外部通信を行わないが、CloudWatchやS3等AWS内部通信はこのルールで許可される
  # -------------------------------------------------------------
  egress {
    from_port   = 0       # 全ポート
    to_port     = 0       # 全ポート
    protocol    = "-1"        # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "portfolio-rds-sg"
  }
}

# -------------------------------------------------------------
# セキュリティグループの作成：メンテナンスEC2用
# 自分のIPからのSSHのみ許可
# -------------------------------------------------------------
resource "aws_security_group" "portfolio_bastion_ec2_sg" {
  name        = "portfolio-bastion-ec2-sg"
  description = "Allow SSH from MyIP only"
  vpc_id      = aws_vpc.portfolio_vpc.id

  # -------------------------------------------------------------
  # インバウンドルール：SSH (TCP 22) ← 自分のグローバルIPアドレスからのみ許可
  # -------------------------------------------------------------
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.9.17.33/32"]
  }

  # -------------------------------------------------------------
  # アウトバウンドルール：全トラフィックを許可（デフォルト設定）
  # -------------------------------------------------------------
  egress {
    from_port   = 0       # 全ポート
    to_port     = 0       # 全ポート
    protocol    = "-1"        # すべてのプロトコル
    cidr_blocks = ["0.0.0.0/0"]       # 送信先は全世界
  }

  tags = {
    Name = "portfolio-bastion-ec2-sg"
  }
}