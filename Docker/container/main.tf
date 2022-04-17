terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.14.0"
    }
  }
}
 
resource "docker_container" "container" {
    name = var.v_con_name
    image = var.v_image
    ports {
        internal = var.v_int_port
        external = var.v_ext_port
    }
}