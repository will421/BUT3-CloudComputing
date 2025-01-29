terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "image_hello_world" {
  name = "docker.io/hello-world"
}

resource "docker_container" "hello_world" {
  name  = "hello-world"
  image = docker_image.image_hello_world.image_id
}