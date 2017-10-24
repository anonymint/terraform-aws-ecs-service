#####
# ECS Service
#####

resource "aws_ecs_task_definition" "this" {
  family                = "${var.service_name}"
  container_definitions = "${var.container_definition}"
}

resource "aws_ecs_service" "this" {
  name            = "${var.service_name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.this.arn}"
  iam_role        = "${var.ecs_service_role_arn}"
  desired_count   = "${var.container_count}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.this.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = ["aws_alb.this"]
}

#####
# ALB
#####
resource "aws_alb" "this" {
  name            = "${var.service_name}-alb"
  internal        = true
  security_groups = "${var.security_groups}"
  subnets         = "${var.subnet_ids}"
}

resource "aws_alb_target_group" "this" {
  name     = "${var.service_name}-targetgroup"
  port     = "${var.container_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    matcher = "200-499"
  }
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = "${aws_alb.this.arn}"
  port              = "${var.alb_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.this.arn}"
    type             = "forward"
  }
}
