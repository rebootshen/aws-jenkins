terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# # Pulls the image
# resource "docker_image" "ubuntu" {
#   name = "ubuntu:latest"
# }

# # Create a container
# resource "docker_container" "foo" {
#   image = docker_image.ubuntu.image_id
#   name  = "foo"
# }






# Jenkins Volume
resource "docker_volume" "jenkins_volume" {
  name = "jenkins_data"
}

# Start the Jenkins Container
resource "docker_container" "jenkins_container" {
  name  = "jenkins"
  image = "jenkins:terraform"
  ports {
    internal = "8080"
    external = "8080"
  }

  volumes {
    volume_name    = "${docker_volume.jenkins_volume.name}"
    container_path = "/var/jenkins_home"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
}
