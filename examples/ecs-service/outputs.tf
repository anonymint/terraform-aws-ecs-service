output "alb_url" {
  value = "${module.ecs-service.alb_url}"
}

output ecs_service_name {
  value = "${module.ecs-service.ecs_service_name}"
}

output ecs_task_definition {
  value = "${module.ecs-service.ecs_task_definition}"
}
