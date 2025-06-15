# -------------------------------------------------------------
# Launch Template：EC2インスタンスの起動テンプレートを定義
# Apacheを自動インストールし、HTMLを配置
# -------------------------------------------------------------
resource "aws_launch_template" "portfolio_launch_template" {
  name_prefix   = "portfolio-launch-template-"
  image_id      = data.aws_ami.amazon_linux.id          # 最新のAmazon Linux 2
  instance_type = "t2.micro"                            # 無料枠対応インスタンスタイプ
  key_name = "Sample"                                   # 自分の環境のキーペア名に変更

  vpc_security_group_ids = [
    aws_security_group.portfolio_ec2_sg.id                        # EC2用セキュリティグループを適用
  ]

  # -------------------------------------------------------------
  # 起動時に実行されるスクリプト（Apacheインストール + HTML配置）
  # -------------------------------------------------------------
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Deployed via ASG in $(hostname)</h1>" > /var/www/html/index.html
              EOF
            )

  # -------------------------------------------------------------
  # EC2インスタンスにタグを付ける設定(起動テンプレート側)
  # -------------------------------------------------------------
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "portfolio-web-ec2"
    }
  }

  # -------------------------------------------------------------
  # 古いテンプレートを削除する前に新しいものを作成(ダウンタイム回避)
  # -------------------------------------------------------------
  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------------------------------------
# データソース：Amazon Linux 2 の最新AMIを取得
# -------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]       # Amazon Linux公式のオーナーID
}

# -------------------------------------------------------------
# Auto Scaling Group（ASG）の作成
# EC2をAZ1a・1cにそれぞれ起動し、ALBターゲットグループに連携
# -------------------------------------------------------------
resource "aws_autoscaling_group" "portfolio_asg" {
  name                      = "portfolio-asg"                      # ASG名
  desired_capacity          = 2                                   # 希望台数（Desired）
  min_size                  = 1                                   # 最小台数
  max_size                  = 2                                   # 最大台数

  vpc_zone_identifier       = [
    aws_subnet.portfolio_private_subnet_1a_app.id,                          # App層1aサブネット
    aws_subnet.portfolio_private_subnet_1c_app.id                           # App層1cサブネット
  ]

  launch_template {
    id      = aws_launch_template.portfolio_launch_template.id     # 起動テンプレートのID
    version = "$Latest"                                           # 最新バージョンを使用
  }

  target_group_arns         = [aws_lb_target_group.portfolio_web_tg.arn]    # ALBターゲットグループに連携

  health_check_type         = "ELB"                               # ALBを用いたヘルスチェック
  health_check_grace_period = 300                                 # 起動後の猶予時間（秒）

  termination_policies      = ["OldestInstance"]                  # 最も古いインスタンスを優先削除

  # -------------------------------------------------------------
  # インスタンスにタグを自動付与(ASG側)
  # -------------------------------------------------------------
  tag {
    key                 = "Name"
    value               = "portfolio-web-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true        # ダウンタイムを避けるため、先に新リソースを作成してから古いものを削除
  }
}