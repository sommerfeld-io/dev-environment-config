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

resource "github_actions_secret" "github_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.github.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "github_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.github.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
