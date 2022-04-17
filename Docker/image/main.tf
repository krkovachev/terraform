terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.14.0"
    }
  }
}

resource "docker_image" "img-web" {
  name         = var.v_image
}