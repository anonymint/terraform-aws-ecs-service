module "ecs-service" {
  source = "../../"

  service_name         = "${var.container_name}-service"
  ecs_cluster_id       = "chaos-sre"
  container_definition = "${data.template_file.container_definition.rendered}"
  container_name       = "${var.container_name}"
  container_port       = "${var.container_port}"
  vpc_id               = "vpc-e7368081"
  security_groups      = ["sg-62fd141e", "sg-51fd142d", "sg-6ffd1413"]
  subnet_ids           = ["subnet-ecdebdb7", "subnet-a1c09be8", "subnet-8e0075a3"]
  ecs_service_role_arn = "arn:aws:iam::152303423357:role/chaos-sre-ecs-service-role"
}

data "template_file" "container_definition" {
  # can be file
  template = "${file("${path.module}/task.tpl")}"

  vars {
    container_name  = "${var.container_name}"
    container_image = "${var.container_name}"
    container_port  = "${var.container_port}"
  }
}

variable container_name {
  default = "nginx-task"
}

variable "container_image" {
  default = "nginx"
}

variable "container_port" {
  default = "80"
}

output "alb_url" {
  value = "${module.ecs-service.alb_url}"
}

output ecs_service_name {
  value = "${module.ecs-service.ecs_service_name}"
}

output ecs_task_definition {
  value = "${module.ecs-service.ecs_task_definition}"
}
