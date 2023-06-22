#!/bin/bash
# @file new-repository.sh
# @brief bootstrap script that can create a new repository in the
# link:https://github.com/sommerfeld-io[sommerfeld-io GitHub organization] and configure it
# accordingly, in order to streamline the process of setting up new repositories.
#
# @description Creating new repositories for various projects is a recurring task. Manually
# creating the repository, configuring its settings, and initializing it with the necessary
# files and structure is time-consuming and prone to human error.
#
# This bootstrap script automates the creation, configuration, and initialization of new
# repositories in the sommerfeld-io GitHub organization to save time and effort while maintaining
# consistency and reducing the risk of human error.
#
# This script handles all the necessary steps, including configuration and initialization. This
# script relies on `xref:AUTO-GENERATED:bash-docs/src/main/github-config/bootstrap-sh.adoc[src/main/github-config/bootstrap.sh]`
# for initalizing the repository.
#
# NOTE: This script is intended to work interactively. So it relies on user input and is not designed
# to work inside e.g. a GitHub Actions workflow.
#
# === Prerequisites
#
# This script needs a working Git and link:https://cli.github.com/[Github CLI] installation.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# curl https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/main/src/main/github-config/new-repository.sh | bash -
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# Download and include logging library
rm -rf /tmp/bash-lib
mkdir -p /tmp/bash-lib
curl -sL https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/modules/bash-script/assets/lib/log.sh --output /tmp/bash-lib/log.sh
source /tmp/bash-lib/log.sh


readonly ORGANIZATION="sommerfeld-io"


LOG_INFO "Create a new repository in the $ORGANIZATION GitHub organization"
LOG_WARN "Make sure to clone the repo (last step of the interactive repo creation)"
gh auth login
gh repo create


LOG_INFO "Choose directory to change into"
LOG_WARN "Make sure to choose the newly created and cloned repo"
select dir in ./*; do
  (
    LOG_INFO "Change directory"
    cd "$dir" || exit
    
    LOG_INFO "Initialize woprkflows, issue templates, linter definitions, etc."
    curl https://raw.githubusercontent.com/sommerfeld-io/dev-environment-config/main/src/main/github-config/bootstrap.sh | bash -

    LOG_INFO "Configure the remote repository"
    gh repo edit \
        --enable-discussions \
        --enable-issues \
        --enable-projects \
        --enable-wiki=false \
        --visibility=public
  )
  break
done
