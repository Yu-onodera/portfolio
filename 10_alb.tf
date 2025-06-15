# -------------------------------------------------------------
# ALB（Application Load Balancer）の作成
# -------------------------------------------------------------
resource "aws_lb" "portfolio_alb" {
  name               = "portfolio-alb"
  internal           = false        # 外部公開用ALB(trueにすると内部ALB)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.portfolio_alb_sg.id]
  subnets            = [
    aws_subnet.portfolio_public_subnet_1a.id,
    aws_subnet.portfolio_public_subnet_1c.id
  ]

  tags = {
    Name = "portfolio-alb"
  }
}

# -------------------------------------------------------------
# ALBリスナー（ポート80）
# -------------------------------------------------------------
resource "aws_lb_listener" "portfolio_http_listener" {
  load_balancer_arn = aws_lb.portfolio_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {        # デフォルトアクション : ALBで受けたリクエストをターゲットグループに転送
    type             = "forward"
    target_group_arn = aws_lb_target_group.portfolio_web_tg.arn
  }
}

# -------------------------------------------------------------
# ターゲットグループの作成（EC2向け）
# -------------------------------------------------------------
resource "aws_lb_target_group" "portfolio_web_tg" {
  name     = "portfolio-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.portfolio_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"       # 正常とみなすステータスコード(HTTP 200)
    interval            = 30          # ヘルスチェック間隔(秒)
    timeout             = 5           # タイムアウト時間(秒)
    healthy_threshold   = 2           # 連続で正常と判断される回数(2回でhealthyに)
    unhealthy_threshold = 2           # 連続で異常と判断される回数(2回でunhealthyに)
  }

  tags = {
    Name = "portfolio-web-tg"
  }
}