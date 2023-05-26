resource "github_repository_file" "linter_adoc_links" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Linter definition update"
  overwrite_on_create = true
  file                = ".adoc-links.json"
  content             = file("${path.module}/assets/linters/.adoc-links.json")
}

resource "github_repository_file" "linter_folderslint" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Linter definition update"
  overwrite_on_create = true
  file                = ".folderslintrc"
  content             = file("${path.module}/assets/linters/.folderslintrc")
}

resource "github_repository_file" "linter_lslint" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Linter definition update"
  overwrite_on_create = true
  file                = ".ls-lint.yml"
  content             = file("${path.module}/assets/linters/.ls-lint.yml")
}

resource "github_repository_file" "linter_shellcheck" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Linter definition update"
  overwrite_on_create = true
  file                = ".shellcheckrc"
  content             = file("${path.module}/assets/linters/.shellcheckrc")
}

resource "github_repository_file" "linter_yamllint" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Linter definition update"
  overwrite_on_create = true
  file                = ".yamllint.yml"
  content             = file("${path.module}/assets/linters/.yamllint.yml")
}
