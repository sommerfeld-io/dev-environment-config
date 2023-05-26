# Repository
# https://github.com/sommerfeld-io/dev-environment-config

data "github_repository" "dev-environment-config" {
  full_name = "sommerfeld-io/dev-environment-config"
}

module "dev-environment-config-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.dev-environment-config.id
  project   = var.default_project
}
