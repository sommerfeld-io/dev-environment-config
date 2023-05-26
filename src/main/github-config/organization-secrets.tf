data "bitwarden_item_login" "GOOGLE_CHAT_WEBHOOK" {
  id = "e2e02ec2-580b-4823-94bb-af70014ca324"
}

data "bitwarden_item_login" "GH_TOKEN_PROJECT_HOUSEKEEPING" {
  id = "d009712e-5f91-42fc-abdd-b00d00cf1948"
}

# data "bitwarden_item_login" "SNYK_TOKEN" {
#   id = "18d29e31-c440-4b59-9992-af7100cc6990"
# }

# data "bitwarden_item_login" "DOCKERHUB_USER" {
#   id = "58479137-3c07-4592-86c2-af7100d020ba"
# }

resource "github_actions_organization_secret" "GOOGLE_CHAT_WEBHOOK" {
  secret_name     = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.username
  plaintext_value = data.bitwarden_item_login.GOOGLE_CHAT_WEBHOOK.password
  visibility      = "all"
}

resource "github_actions_organization_secret" "GH_TOKEN_PROJECT_HOUSEKEEPING" {
  secret_name     = data.bitwarden_item_login.GH_TOKEN_PROJECT_HOUSEKEEPING.username
  plaintext_value = data.bitwarden_item_login.GH_TOKEN_PROJECT_HOUSEKEEPING.password
  visibility      = "all"
}
