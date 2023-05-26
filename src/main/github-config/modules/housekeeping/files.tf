resource "github_repository_file" "files_gitignore" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] .gitignore update"
  overwrite_on_create = true
  file                = ".gitignore"
  content             = file("${path.module}/assets/files/.gitignore")
}
