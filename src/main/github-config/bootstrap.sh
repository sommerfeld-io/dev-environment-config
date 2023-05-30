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
# * *$1* (string): Some var
# TODO update arguments
#
# === Script Example
#
# [source, bash]
# ```
# ./bootstrap.sh
#
# curl https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/automated-repository-housekeeping/src/main/github-config/bootstrap.sh | bash -
# TODO URL from main branch
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# BaseURL of this repository including branch
readonly GITHUB_BASEURL="https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/automated-repository-housekeeping"


readonly FOLDER_GITHUB=".github"
if [ ! -d "$FOLDER_GITHUB" ] 
then
    echo -e "$LOG_ERROR Expected directory $FOLDER_GITHUB to be present"
    echo -e "$LOG_ERROR Check if the current working directory is the project root"
    exit 8
fi


# readonly LOG_DONE="[\e[32mDONE\e[0m]"
# readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"
# readonly LOG_WARN="[\e[93mWARN\e[0m]"
# readonly Y="\e[93m"
# readonly P="\e[35m"
# readonly D="\e[0m"
# readonly G='\033[1;30m'


echo -e "$LOG_INFO Run bootstrap script to provision github repository"


echo -e "$LOG_INFO Create workflow files"
readonly workflow_files=(
    "housekeeping-labels.yml"
    "housekeeping-issues.yml"
)

for wf in "${workflow_files[@]}"
do 
    echo -e "$LOG_INFO Create $wf"
    curl "$GITHUB_BASEURL/src/main/github-config/assets/workflows/$wf" --output "$FOLDER_GITHUB/workflows/$wf"
done
