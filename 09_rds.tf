# -------------------------------------------------------------
# RDS用のサブネットグループの作成（Private Subnet × 2AZ）
# -------------------------------------------------------------
resource "aws_db_subnet_group" "portfolio_db_subnet_group" {
  name       = "portfolio-db-subnet-group"
  subnet_ids = [
    aws_subnet.portfolio_private_subnet_1a_db.id,
    aws_subnet.portfolio_private_subnet_1c_db.id
  ]
  tags = {
    Name = "portfolio-db-subnet-group"
  }
}

# -------------------------------------------------------------
# RDSインスタンスの作成（MySQL 8.0 / マルチAZ / Private Subnet）
# - パブリックIPなし、Private Subnet + SG制御でセキュリティを確保
# - マルチAZ構成により耐障害性を向上(1a / 1c に自動冗長)
# -------------------------------------------------------------
resource "aws_db_instance" "portfolio_db" {
  identifier              = "portfolio-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"                         # 無料枠対応
  allocated_storage       = 20                                    # ストレージ容量（GiB）
  storage_type            = "gp2"
  max_allocated_storage   = 100                                   # オートスケーリング上限
  db_name                 = "portfoliodb"                          # 任意のDB名
  username                = "admin"
  password                = "admin1234"                           # 実務では variables.tf + secrets manager 推奨
  skip_final_snapshot     = true                                  # 削除時スナップショットを作成しない
  deletion_protection     = false
  publicly_accessible     = false                                 # パブリックアクセス無効
  multi_az                = true                                  # マルチAZ構成
  vpc_security_group_ids  = [aws_security_group.portfolio_rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.portfolio_db_subnet_group.name

  tags = {
    Name = "portfolio-db"
  }
}