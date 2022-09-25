project = "init"

runner {
  enabled = true
  profile = "nomad-bootstrap-profile"
  data_source "git" {
    url = "https://github.com/dotdiego/waypoint-test.git"
    path = "init"
  }
}