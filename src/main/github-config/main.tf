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
