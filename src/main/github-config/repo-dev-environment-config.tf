# Repository
# https://github.com/sommerfeld-io/dev-environment-config

data "github_repository" "dev-environment-config" {
  full_name = "sommerfeld-io/dev-environment-config"
}

module "dev-environment-config-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.dev-environment-config.id
  project   = "https://github.com/orgs/sommerfeld-io/projects/1"
}

resource "github_actions_secret" "dev-environment-config_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.dev-environment-config.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "dev-environment-config_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.dev-environment-config.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
