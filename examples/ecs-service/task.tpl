[
  {
    "name": "${container_name}",
    "image": "${container_image}",
    "cpu": 100,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port},
        "hostPort": 0,
        "protocol": "tcp"
      }
    ]
  }
]