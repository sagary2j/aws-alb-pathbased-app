
resource "aws_alb" "alb" {
  name               = "${var.prefix}-alb"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = aws_subnet.subnet_public.*.id
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_alb_target_group" "target-group" {
  name     = "${var.prefix}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  lifecycle { create_before_destroy = true }
  depends_on = [aws_alb.alb]

  health_check {
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}
resource "aws_alb_target_group" "target-group-1" {
  name     = "${var.prefix}-target-group-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  lifecycle { create_before_destroy = true }
  depends_on = [aws_alb.alb]

  health_check {
    path                = "/app1/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "target-group-2" {
  name     = "${var.prefix}-target-group-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  lifecycle { create_before_destroy = true }
  depends_on = [aws_alb.alb]

  health_check {
    path                = "/app2/index.html"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_alb_target_group.target-group.arn
  target_id        = aws_instance.application[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_alb_target_group.target-group-1.arn
  target_id        = aws_instance.application[0].id
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_alb_target_group.target-group-2.arn
  target_id        = aws_instance.application[1].id
  port             = 80
}

resource "aws_alb_listener" "alb-listener" {
  default_action {
    target_group_arn = aws_alb_target_group.target-group.arn
    type             = "forward"
  }
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
}

# Create Listener Rules
resource "aws_lb_listener_rule" "rule-1" {
  action {
    target_group_arn = aws_alb_target_group.target-group-1.arn
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["/app1/*"]
    }
  }

  listener_arn = aws_alb_listener.alb-listener.id
  priority     = 100
}

resource "aws_lb_listener_rule" "rule-2" {
  action {
    target_group_arn = aws_alb_target_group.target-group-2.arn
    type             = "forward"
  }


  condition {
    path_pattern {
      values = ["/app2/*"]
    }
  }

  listener_arn = aws_alb_listener.alb-listener.id
  priority     = 101
}
