project = "init"

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type      = string
  sensitive = true
}

runner {
  enabled = true
  profile = "nomad-bootstrap-profile"
  data_source "git" {
    url = "https://github.com/dotdiego/waypoint-test.git"
  }
}

app "demo" {
  build {
    use "docker-pull" {
      image              = "alpine"
      tag                = "latest"
      disable_entrypoint = true
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