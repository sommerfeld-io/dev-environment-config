terraform {
  required_version = "1.3.7"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }

    github = {
      source  = "integrations/github"
      version = "5.23.0"
    }

    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "0.6.1"
    }
  }
}

provider "local" {}

provider "github" {}

provider "bitwarden" {
  master_password = var.bw_password
  client_id       = var.bw_client_id
  client_secret   = var.bw_client_secret
  email           = var.bw_email
  server          = "https://vault.bitwarden.com"
}



# ==============================================================
#   Global github actions secrets
#   Relevant for all repos
# ==============================================================

data "bitwarden_item_login" "GOOGLE_CHAT_WEBHOOK" {
  id = "e2e02ec2-580b-4823-94bb-af70014ca324"
}

data "bitwarden_item_login" "GH_TOKEN_REPO_AND_PROJECT" {
  id = "d009712e-5f91-42fc-abdd-b00d00cf1948"
}

# data "bitwarden_item_login" "SNYK_TOKEN" {
#   id = "18d29e31-c440-4b59-9992-af7100cc6990"
# }

# data "bitwarden_item_login" "DOCKERHUB_USER" {
#   id = "58479137-3c07-4592-86c2-af7100d020ba"
# }
