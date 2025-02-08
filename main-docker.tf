terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "dev_network" {
  name = "dev_network"
}

resource "docker_volume" "jenkins_home" {}
resource "docker_volume" "sonarqube_data" {}
resource "docker_volume" "sonarqube_logs" {}
resource "docker_volume" "sonarqube_extensions" {}
resource "docker_volume" "postgresql" {}
resource "docker_volume" "postgresql_data" {}

resource "docker_container" "jenkins" {
  name  = "jenkins"
  image = "jenkins/jenkins:lts"
  restart = "always"

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 50000
    external = 50000
  }

  volumes {
    volume_name    = docker_volume.jenkins_home.name
    container_path = "/var/jenkins_home"
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }
}

resource "docker_container" "db" {
  name  = "sonar_db"
  image = "postgres:13"
  restart = "always"

  env = [
    "POSTGRES_USER=sonar",
    "POSTGRES_PASSWORD=sonar",
    "POSTGRES_DB=sonar"
  ]

  volumes {
    volume_name    = docker_volume.postgresql.name
    container_path = "/var/lib/postgresql"
  }

  volumes {
    volume_name    = docker_volume.postgresql_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }
}

resource "docker_container" "sonarqube" {
  name  = "sonarqube"
  image = "sonarqube:lts"
  restart = "always"

  ports {
    internal = 9000
    external = 9000
  }

  env = [
    "SONAR_JDBC_URL=jdbc:postgresql://sonar_db:5432/sonar",
    "SONAR_JDBC_USERNAME=sonar",
    "SONAR_JDBC_PASSWORD=sonar"
  ]

  volumes {
    volume_name    = docker_volume.sonarqube_data.name
    container_path = "/opt/sonarqube/data"
  }

  volumes {
    volume_name    = docker_volume.sonarqube_logs.name
    container_path = "/opt/sonarqube/logs"
  }

  volumes {
    volume_name    = docker_volume.sonarqube_extensions.name
    container_path = "/opt/sonarqube/extensions"
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }

  depends_on = [docker_container.db]
}
