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

resource "github_repository_file" "workflow_ci" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  commit_author       = "sebastian-sommerfeld-io"
  commit_email        = "sebastian@sommerfeld.io"
  overwrite_on_create = false
  file                = ".github/workflows/ci.yml"
  content = templatefile("${path.module}/assets/workflows/ci-tftpl.yml", {
    project      = "${var.project}"
  })
}

resource "github_repository_file" "workflow_docs_as_code" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  commit_author       = "sebastian-sommerfeld-io"
  commit_email        = "sebastian@sommerfeld.io"
  overwrite_on_create = false
  file                = ".github/workflows/docs-as-code.yml"
  content = templatefile("${path.module}/assets/workflows/docs-as-code-tftpl.yml", {
    project      = "${var.project}"
  })
}

resource "github_repository_file" "dependabot" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update dependabot config"
  commit_author       = "sebastian-sommerfeld-io"
  commit_email        = "sebastian@sommerfeld.io"
  overwrite_on_create = false
  file                = ".github/dependabot.yml"
  content = templatefile("${path.module}/assets/workflows/dependabot-tftpl.yml", {
    project      = "${var.project}"
  })
}

