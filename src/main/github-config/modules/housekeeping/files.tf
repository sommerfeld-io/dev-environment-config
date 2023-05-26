resource "github_repository_file" "files_gitignore" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] .gitignore update"
  overwrite_on_create = true
  file                = ".gitignore"
  content             = file("${path.module}/assets/files/.gitignore")
}

resource "github_repository_file" "files_gitpod" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Gitpod update"
  overwrite_on_create = true
  file                = ".gitpod.yml"
  content             = file("${path.module}/assets/files/.gitpod.yml")
}
