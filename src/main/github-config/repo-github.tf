# Repository
# https://github.com/sommerfeld-io/.github

data "github_repository" "github" {
  full_name = "sommerfeld-io/.github"
}

module "github-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.github.id
  project   = "https://github.com/orgs/sommerfeld-io/projects/1"
}
