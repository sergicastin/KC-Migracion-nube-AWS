resource "aws_ecs_cluster" "kc-nginx_cluster-sergi" {
  name = "kc-nginx-cluster-sergi"
}

resource "aws_ecs_task_definition" "kc-nginx_task-sergi" {
  family                   = "kc-nginx-task-sergi"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name            = "kc-nginx-container-sergi"
      image           = "nginx:latest"
      essential       = true
      portMappings    = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_lb" "kc-nginx_lb-sergi" {
  name               = "kc-nginx-lb-sergi"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.kc-subnet-sergi-1.id, aws_subnet.kc-subnet-sergi-2.id]
  security_groups    = [aws_security_group.kc-nginx-sergi.id]
}

resource "aws_lb_target_group" "kc-nginx_lb_target_group-sergi_2" {
  name        = "kc-nginx-lb-target-group-sergi"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.kc-vpc-sergi.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.kc-nginx_lb-sergi.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kc-nginx_lb_target_group-sergi_2.arn
  }
}

resource "aws_ecs_service" "kc-nginx_service-sergi" {
  name            = "kc-nginx-service-sergi"
  cluster         = aws_ecs_cluster.kc-nginx_cluster-sergi.id
  task_definition = aws_ecs_task_definition.kc-nginx_task-sergi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.kc-nginx_lb_target_group-sergi_2.arn
    container_name   = "kc-nginx-container-sergi"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.kc-subnet-sergi-1.id]
    security_groups  = [aws_security_group.kc-nginx-sergi.id]
  }

  depends_on = [aws_lb_listener.front_end]
}
