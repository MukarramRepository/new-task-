# -----------------------------
# Data: Latest Amazon Linux 2 AMI
# -----------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# -----------------------------
# ALB (Application Load Balancer)
# -----------------------------
resource "aws_lb" "alb" {
  name                       = "${var.env}-alb"
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public[*].id
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200,302"
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# -----------------------------
# IAM Instance Profile for EC2 (ECR + SSM)
# -----------------------------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.env}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# -----------------------------
# Launch Template (EC2 for AutoScaling)
# -----------------------------
resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.env}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = <<EOF
#!/bin/bash
# Install Docker and run container
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
docker pull ${var.ecr_repo}:${var.app_image_tag}
docker run -d -p 80:80 ${var.ecr_repo}:${var.app_image_tag}
EOF
}
