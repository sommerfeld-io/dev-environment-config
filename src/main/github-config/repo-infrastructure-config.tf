# Repository
# https://github.com/sommerfeld-io/infrastructure-config

data "github_repository" "infrastructure-config" {
  full_name = "sommerfeld-io/infrastructure-config"
}

module "infrastructure-config-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.infrastructure-config.id
  project   = var.default_project
}
