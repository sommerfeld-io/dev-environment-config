# Repository
# https://github.com/sommerfeld-io/website

data "github_repository" "website" {
  full_name = "sommerfeld-io/website"
}

module "website-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.website.id
  project   = var.default_project
}
