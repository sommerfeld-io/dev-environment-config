#!/bin/bash
# @file apply-config.sh
# @brief Apply a consistent configuration for all (relevant) Github repositories.
#
# @description This script applies a consistent configuration across all
# link:https://github.com/sommerfeld-io[Github repositories]. using Terraform. The
# link:https://registry.terraform.io/providers/integrations/github/latest/docs[Terraform Github Provider]
# allows interaction with Github.
#
# Terraform is started inside a link:https://www.docker.com/[Docker] container, so there is no need
# to install Terraform or any other software on your machine. Only Docker is required.
#
# Terraform is an open-source infrastructure as code software tool that enables you to safely and
# predictably create, change, and improve infrastructure. It provides infrastructure automation with
# workflows to build composition, collaboration, and reuse of infrastructure as code.
#
# .Available Terraform commands
# include::ROOT:partial$GENERATED/github-config/help.adoc[]
#
# Use `xref:AUTO-GENERATED:bash-docs/src/main/github/run-local-sh.adoc[run-local.sh]` while developing
# on your localhost instead of direct calls to this script. `run-local.sh` provides a more conviniert
# way to trigger the terraform commands.
#
# === Script Arguments
#
# * *$1* (string): The ``terraform`` command to run - Mandatory
# * *$2* (string): Github token ... when running on localhost pass a token from anywhere, when running in a Github Actions workflow pass ``${{ secrets.GITHUB_TOKEN }}`` - Mandatory for ``plan`` and ``apply``
# * *$3* (string): Bitwarden client id ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - Mandatory for ``plan`` and ``apply``
# * *$4* (string): Bitwarden client secret ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - Mandatory for ``plan`` and ``apply``
# * *$5* (string): Bitwarden master password ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - Mandatory for ``plan`` and ``apply``
#
# === Script Example
#
# To run this script locally, run the commands in the same order as the pipeline does (see docs for
# each function). Running this script without arguments will result in an error.
#
# [source, bash]
# ```
# ./apply-config.sh init
# ./apply-config.sh lint
# ./apply-config.sh validate
# ./apply-config.sh fmt
# ./apply-config.sh plan "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
# ./apply-config.sh apply "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
# ./apply-config.sh cleanup
# ```


# Avoid 'unbound variable' errors in pipeline
readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"
readonly LOG_DONE="[\e[32mDONE\e[0m]"
#readonly Y="\e[93m"
readonly P="\e[35m"
readonly D="\e[0m"

readonly OPTION_APPLY="apply"
readonly OPTION_CLEANUP="cleanup"
readonly OPTION_FORMAT="fmt"
readonly OPTION_INITIALIZE="init"
readonly OPTION_LINT="lint"
readonly OPTION_PLAN="plan"
readonly OPTION_VALIDATE="validate"
readonly OPTION_VERSION="-version"

readonly TF_PLAN_FILE="tfplan"
readonly DATA_REPO_PATH="../../../target/tmp/repos"
readonly DATA_REPO_NAME="dev-environment-config"
readonly TF_STATE_PATH="data/github-config"
readonly TF_STATE_FILE="terraform.tfstate"
readonly GITHUB_ACTIONS_USER="runner"


TF_COMMAND="$1"
if [ -z "$TF_COMMAND" ]; then
    echo -e "$LOG_ERROR Param missing: Terraform command"
    echo -e "$LOG_ERROR Available arguments are:"
    cat assets/help.adoc
    echo -e "$LOG_ERROR exit" && exit 8
fi
readonly TF_COMMAND


if [ "$TF_COMMAND" = "$OPTION_PLAN" ] || [ "$TF_COMMAND" = "$OPTION_APPLY" ]; then

    TOKEN="$2"
    if [ -z "$TOKEN" ]; then
        echo -e "$LOG_ERROR Param missing: Github Token"
        echo -e "$LOG_ERROR exit" && exit 8
    fi
    readonly TOKEN


    BW_CLIENT_ID="$3"
    if [ -z "$BW_CLIENT_ID" ]; then
        echo -e "$LOG_ERROR Param missing: Bitwarden client id"
        echo -e "$LOG_ERROR exit" && exit 8
    fi
    readonly BW_CLIENT_ID


    BW_CLIENT_SECRET="$4"
    if [ -z "$BW_CLIENT_SECRET" ]; then
        echo -e "$LOG_ERROR Param missing: Bitwarden client secret"
        echo -e "$LOG_ERROR exit" && exit 8
    fi
    readonly BW_CLIENT_SECRET


    BW_MASTER_PASS="$5"
    if [ -z "$BW_MASTER_PASS" ]; then
        echo -e "$LOG_ERROR Param missing: Bitwarden client master pass"
        echo -e "$LOG_ERROR exit" && exit 8
    fi
    readonly BW_MASTER_PASS

fi


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description Wrapper function to encapsulate terraform in a Docker container. The current working
# directory is mounted into the container and selected as working directory so that all files are
# available to terraform. Paths are preserved. The container runs with the current user.
#
# When running ``plan`` or ``apply``: All mandatory tokens, secrets, etc. which are passed to the
# script (see "link:#_script_arguments[Script Arguments]"), are    configured as environment variables
# for the container.
# 
# @example
#        terraform -version
#
# @arg $@ String The terraform commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with terraform command is missing
function terraform() {
    if [ -z "$1" ]; then
        echo -e "$LOG_ERROR No command passed to the terraform container"
        echo -e "$LOG_ERROR exit" && exit 8
    fi

    local DOCKER_IMAGE="sommerfeldio/terraform:0.1.1"
    
    if [ "$TF_COMMAND" = "$OPTION_PLAN" ] || [ "$TF_COMMAND" = "$OPTION_APPLY" ]; then
        docker run --rm \
            --volume /etc/passwd:/etc/passwd:ro \
            --volume /etc/group:/etc/group:ro \
            --user "$(id -u):$(id -g)" \
            --volume /etc/timezone:/etc/timezone:ro \
            --volume /etc/localtime:/etc/localtime:ro \
            --volume "$(pwd):$(pwd)" \
            --workdir "$(pwd)" \
            --env "GITHUB_TOKEN=$TOKEN" \
            --env "GITHUB_OWNER=sommerfeld-io" \
            --env "TF_VAR_bw_client_id=$BW_CLIENT_ID" \
            --env "TF_VAR_bw_client_secret=$BW_CLIENT_SECRET" \
            --env "TF_VAR_bw_password=$BW_MASTER_PASS" \
            "$DOCKER_IMAGE" "$@"
    else
        docker run --rm \
            --volume /etc/passwd:/etc/passwd:ro \
            --volume /etc/group:/etc/group:ro \
            --user "$(id -u):$(id -g)" \
            --volume /etc/timezone:/etc/timezone:ro \
            --volume /etc/localtime:/etc/localtime:ro \
            --volume "$(pwd):$(pwd)" \
            --workdir "$(pwd)" \
            "$DOCKER_IMAGE" "$@"
    fi
}


# @description Apply this configuration by running ``terraform apply -auto-approve``.
#
# @example
#    apply
function apply() {
    terraform apply -auto-approve "$TF_PLAN_FILE"

    rm "$TF_PLAN_FILE"
    cp "$TF_STATE_FILE" "$DATA_REPO_PATH/$DATA_REPO_NAME/$TF_STATE_PATH/$TF_STATE_FILE"

    (
        cd "$DATA_REPO_PATH/$DATA_REPO_NAME" || exit
        echo -e "$LOG_INFO Current directory = $(pwd)"
        
        if [ "$USER" = "$GITHUB_ACTIONS_USER" ]; then
            git config --global user.email "sebastian@sommerfeld.io"
            git config --global user.name "sebastian-sommerfeld-io"
        fi

        git add "$TF_STATE_PATH/$TF_STATE_FILE"
        git commit -m "[Actions Bot] auto-updated terraform state"
        git push
    )
}


# @description Remove all temporary files. When running in a pipeline, this step is always invoked.
#
# @example
#    apply
function cleanup() {
    rm -rf .terraform
    rm -f .terraform.lock*
    rm -f "$TF_PLAN_FILE"*
    rm -f "$TF_STATE_FILE"*
    rm -rf "$DATA_REPO_PATH"
    rm -rf .bitwarden
}


# @description Apply consistent format to all ``*.tf`` files by running ``terraform fmt -recursive``.
#
# @example
#        fmt
function format() {
    terraform fmt -recursive
}


# @description Initialize this configuration by running ``terraform init``.
# 
# @example
#        initialize
function initialize() {
    mkdir -p "$DATA_REPO_PATH"
    echo -e "$LOG_INFO Current user = $USER"

    # Pipeline uses dedicated step to clone the repo into this location
    if [ "$USER" != "$GITHUB_ACTIONS_USER" ]; then
        (
            cd "$DATA_REPO_PATH" || exit
            git clone "git@github.com:sommerfeld-io/$DATA_REPO_NAME.git"
        )
    fi
    terraform init
}


# @description Use link:https://github.com/terraform-linters/tflint[terraform-linters/tflint] linter
# (or link:https://github.com/terraform-linters/tflint-bundle[terraform-linters/tflint-bundle] to be
# precice) to check terraform config.
#
# @example
#        lint
function lint() {
    docker run --rm \
        --volume "$(pwd):/data" \
        ghcr.io/terraform-linters/tflint-bundle:latest
}


# @description Plan this configuration by running ``terraform plan``.
#
# @example
#        plan
function plan() {
    cp "$DATA_REPO_PATH/$DATA_REPO_NAME/$TF_STATE_PATH/$TF_STATE_FILE" "$TF_STATE_FILE"
    terraform plan -out="$TF_PLAN_FILE"
}


# @description Validate this configuration by running ``terraform validate``.
#
# @example
#        validate
function validate() {
    terraform validate
}


# @description Show Terraform version by running ``terraform -version``.
#
# @example
#        version
function version() {
    terraform -version
}


echo -e "$LOG_INFO Run Github configuration step: $P$TF_COMMAND$D"
case "$TF_COMMAND" in
    "$OPTION_APPLY" ) apply ;;
    "$OPTION_CLEANUP" ) cleanup ;;
    "$OPTION_FORMAT" ) format ;;
    "$OPTION_INITIALIZE" ) initialize ;;
    "$OPTION_LINT" ) lint ;;
    "$OPTION_PLAN" ) plan ;;
    "$OPTION_VALIDATE" ) validate ;;
    "$OPTION_VERSION" ) version ;;
    * )
        echo -e "$LOG_ERROR Invalid argument"
        echo -e "$LOG_ERROR Available arguments are:"
        cat assets/help.adoc
        ;;
esac
echo -e "$LOG_DONE Finished Github configuration step: $P$TF_COMMAND$D"
