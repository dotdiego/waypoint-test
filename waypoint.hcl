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
  // profile set to avoid kaniko --force issue
  profile = "nomad-bootstrap-profile"
  data_source "git" {
    url = "https://github.com/dotdiego/waypoint-test.git"
  }
}

app "demo" {
  // get a small image from docker because we can't bypass the build step
  build {
    use "docker-pull" {
      image              = "hello-world"
      tag                = "latest"
      disable_entrypoint = true
    }

    // push it to docker registry because remote-runner needs a registry block
    registry {
      use "docker" {
        image    = "${var.registry_username}/hello-world"
        tag      = "latest"
        username = var.registry_username
        password = var.registry_password
      }
    }
  }

  // finally deploy to nomad
  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.project}/webapp.nomad")
    }
  }
}