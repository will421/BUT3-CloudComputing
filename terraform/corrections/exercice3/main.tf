terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

variable "port" {
    default = 8080
}

data "docker_image" "image_nginx" {
  name = "docker.io/nginx"
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = data.docker_image.image_nginx.id

  ports {
    internal = 80
    external = var.port
  }
}

output "ip_externe" {
  value = "localhost:${var.port}"
}

output "ip_interne" {
  value = docker_container.nginx.network_data[0].ip_address
}