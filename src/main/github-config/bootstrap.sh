#!/bin/bash
# @file bootstrap.sh
# @brief Bootstrap script to configure a Github repository for the sommerfeld-io organization.
#
# @description Bootstrap script to configure a Github repository for the
# link:https://github.com/sommerfeld-io[sommerfeld-io] organization. This script creates the
# following objects:
#
# * Github Actions workflows:
# ** housekeeping-issues.yml
# ** housekeeping-labels.yml
# ** housekeeping-repo.yml
# * Issue Templates:
# ** risk-or-technical-debt.md
# ** user-story.md
# * PULL_REQUEST_TEMPLATE.md
#
# Once the initial setup (by running this script) is done, this script is executed regularly by
# a Github actions workflow (`housekeeping-repo.yml`) to ensure settings always stay up-to-date.
#
# === Prerequisites
#
# In order to access Github correctly, the link:https://github.com/sommerfeld-io[sommerfeld-io]
# organization needs the following configs:
#
# * Organisation Secrets
# ** GH_TOKEN_REPO_AND_PROJECT -> The personal access token (classic) which is configured for my user "sebastian-sommerfeld-io". The token needs `admin:org`, project`, `read:user` and `repo` permissions.
# ** GOOGLE_CHAT_WEBHOOK
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# curl https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/main/src/main/github-config/bootstrap.sh | bash -
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# readonly LOG_DONE="[\e[32mDONE\e[0m]"
readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"
# readonly LOG_WARN="[\e[93mWARN\e[0m]"
# readonly Y="\e[93m"
# readonly P="\e[35m"
# readonly D="\e[0m"
# readonly G='\033[1;30m'


# BaseURL of this repository including branch
readonly GITHUB_BASEURL="https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/main"


readonly FOLDER_GITHUB=".github"
if [ ! -d "$FOLDER_GITHUB" ] 
then
    echo -e "$LOG_ERROR Expected directory $FOLDER_GITHUB to be present"
    echo -e "$LOG_ERROR Check if the current working directory is the project root"
    exit 8
fi


# @description Download workflow files from remote repository and write to ``.github`` folder.
#
# @example
#    createWorkflowFiles
function createWorkflowFiles() {
    echo -e "$LOG_INFO Create workflow files"
    mkdir -p "$FOLDER_GITHUB/workflows"

    local files=(
        "housekeeping-labels.yml"
        "housekeeping-issues.yml"
        "housekeeping-repo.yml"
    )

    for file in "${files[@]}"
    do 
        echo -e "$LOG_INFO Create $file"
        curl "$GITHUB_BASEURL/src/main/github-config/assets/workflows/$file" --output "$FOLDER_GITHUB/workflows/$file"
    done
}


# @description Download issue template files from remote repository and write to ``.github`` folder.
#
# @example
#    createIssueTemplates
function createIssueTemplates() {
    echo -e "$LOG_INFO Create issue template files"
    mkdir -p "$FOLDER_GITHUB/ISSUE_TEMPLATE"

    local files=(
        "risk-or-technical-debt.md"
        "user-story.md"
    )

    for file in "${files[@]}"
    do 
        echo -e "$LOG_INFO Create $file"
        curl "$GITHUB_BASEURL/src/main/github-config/assets/templates/$file" --output "$FOLDER_GITHUB/ISSUE_TEMPLATE/$file"
    done
}


# @description Download issue template files from remote repository and write to ``.github`` folder.
#
# @example
#    createPullRequestTemplate
function createPullRequestTemplate() {
    echo -e "$LOG_INFO Create Pull Request template"

    local file="PULL_REQUEST_TEMPLATE.md"
    echo -e "$LOG_INFO Create $file"
    curl "$GITHUB_BASEURL/src/main/github-config/assets/$file" --output "$FOLDER_GITHUB/$file"
}


# @description Download linter rule files from remote repository and write to projects root folde.
#
# @example
#    createLinterRules
function createLinterRules() {
    echo -e "$LOG_INFO Create linter rules"

    local files=(
        ".adoc-links.json"
        ".folderslintrc"
        ".ls-lint.yml"
        ".shellcheckrc"
        ".yamllint.yml"
    )

    for file in "${files[@]}"
    do 
        echo -e "$LOG_INFO Create $file"
        curl "$GITHUB_BASEURL/src/main/github-config/assets/linters/$file" --output "$file"
    done
}


echo -e "$LOG_INFO Run bootstrap script to provision github repository"
createWorkflowFiles
createIssueTemplates
createPullRequestTemplate
createLinterRules
