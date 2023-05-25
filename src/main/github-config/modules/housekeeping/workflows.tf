resource "github_repository_file" "workflow_housekeeping-issues" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  commit_author       = "sebastian-sommerfeld-io"
  commit_email        = "sebastian@sommerfeld.io"
  overwrite_on_create = true
  file                = ".github/workflows/housekeeping-issues.yml"
  content = templatefile("${path.module}/assets/workflows/housekeeping-issues-tftpl.yml", {
    project      = "${var.project}",
    issue_labels = "${var.issue_labels}"
  })
}

resource "github_repository_file" "workflow_housekeeping-labels" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  commit_author       = "sebastian-sommerfeld-io"
  commit_email        = "sebastian@sommerfeld.io"
  overwrite_on_create = true
  file                = ".github/workflows/housekeeping-labels.yml"
  content = templatefile("${path.module}/assets/workflows/housekeeping-labels-tftpl.yml", {
    project      = "${var.project}",
    issue_labels = "${var.issue_labels}"
  })
}
