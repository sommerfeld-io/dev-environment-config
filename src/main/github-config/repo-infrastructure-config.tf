# Repository
# https://github.com/sommerfeld-io/infrastructure-config

data "github_repository" "infrastructure-config" {
  full_name = "sommerfeld-io/infrastructure-config"
}

module "infrastructure-config-housekeeping" {
  source    = "./modules/housekeeping"
  repo_name = data.github_repository.infrastructure-config.id
  project   = "https://github.com/orgs/sommerfeld-io/projects/1"
}

resource "github_actions_secret" "infrastructure-config_GOOGLE_CHAT_WEBHOOK" {
  repository      = data.github_repository.infrastructure-config.id
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
}

resource "github_actions_secret" "infrastructure-config_GH_TOKEN_REPO_AND_PROJECT" {
  repository      = data.github_repository.infrastructure-config.id
  secret_name     = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_REPO_AND_PROJECT.password
}
