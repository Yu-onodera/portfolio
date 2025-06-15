# -------------------------------------------------------------
# 踏み台サーバー（アクセス用EC2）の作成
# - Public Subnetに配置
# - SSH接続やメンテナンス用に利用
# - パブリックIPを付与し、外部からの接続を許可
# -------------------------------------------------------------
resource "aws_instance" "portfolio_bastion_ec2" {
  ami                    = data.aws_ami.amazon_linux.id       # 最新のAmazon Linux 2 AMI
  instance_type          = "t2.micro"                         # 無料枠対応
  subnet_id              = aws_subnet.portfolio_public_subnet_1a.id     # パブリックサブネットに配置
  key_name               = "Sample"                           # SSH接続用のキーペア名
  vpc_security_group_ids = [aws_security_group.portfolio_bastion_ec2_sg.id]       # SSH用セキュリティグループ
  associate_public_ip_address = true                          # パブリックIPを自動割り当て

  tags = {
    Name = "portfolio-bastion-ec2"
  }
}