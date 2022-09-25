project = "init"

variable "registry_username" {
  type    = string
}

variable "registry_password" {
  type    = string
  sensitive = true
}

app "demo" {

  build {
    use "docker-pull" {
      image = "alpine"
      tag   = "latest"
      
    }

    registry {
      use "docker" {
        image    = "${var.registry_username}/alpine"
        tag      = "latest"
        username = var.registry_username
        password = var.registry_password
      }
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.project}/webapp.nomad")
    }
  }
}