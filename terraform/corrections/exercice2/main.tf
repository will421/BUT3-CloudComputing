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

resource "docker_image" "image_nginx" {
  name = "docker.io/nginx"
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.image_nginx.image_id

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