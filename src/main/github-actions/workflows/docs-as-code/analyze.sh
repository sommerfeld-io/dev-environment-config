#!/bin/bash
# @file analyze.sh
# @brief Analyze this projects source code by running Qodana.
#
# @description This script analyzes this projects source code and asciidoc by running
# link:https://www.jetbrains.com/de-de/qodana[Qodana] The script is downloaded by the
# ``docs-as-code.yml`` workflow and executed as part of the workflow.
#
# The base iamge for the custom Docker image which is built during the workflow execution is
# link:https://hub.docker.com/r/jetbrains/qodana[``jetbrains/qodana``].
#
# === Script Arguments
#
# * *$1* (string): Use ``--save-report`` to run in pipelines. When omitting this option a webserver starts at link:http://localhost:8080[localhost:8080].
#
# === Script Example
#
# [source, bash]
# ```
# ./analyze.sh
# ```


readonly PORT="8080"
readonly PIPELINE_MODE="--save-report"
MODE="--show-report"
FLAGS="--rm -it -p $PORT:8080"
if [ "$1" = "$PIPELINE_MODE" ]; then
  MODE="$1"
  FLAGS="--rm"
fi
readonly MODE
readonly FLAGS


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description Log message with log level = ERROR.
#
# @arg $@ String The line to print.
function LOG_ERROR() {
  local LOG_ERROR="[\e[1;31mERROR\e[0m]" 
  echo -e "$LOG_ERROR $1"
}


# @description Log message with log level = INFO.
#
# @arg $@ String The line to print.
function LOG_INFO() {
  local LOG_INFO="[\e[34mINFO\e[0m]"
  echo -e "$LOG_INFO $1"
}


# @description Print log output in a header-style.
#
# @arg $@ String The line to print.
function LOG_HEADER() {
  LOG_INFO "------------------------------------------------------------------------"
  LOG_INFO "$1"
  LOG_INFO "------------------------------------------------------------------------"
}


readonly IMAGE="local/qodana-go:dev"


LOG_HEADER "Build analyzer image"
docker build -t "$IMAGE" .


readonly TARGET_DIR="target/qodana"
LOG_HEADER "Run jetbrains/qodana"
mkdir -p "$TARGET_DIR"
mkdir -p "$TARGET_DIR/cache"

LOG_INFO "Run Qodana (mode = '$MODE', flags = '$FLAGS')"
# shellcheck disable=SC2086
docker run $FLAGS \
  --user "$(id -u):$(id -g)" \
  --volume "$(pwd):/data/project" \
  --volume "$(pwd)/$TARGET_DIR:/data/results" \
  --volume "$(pwd)/$TARGET_DIR/cache:/data/cache" \
  "$IMAGE" "$MODE" \
    --property=idea.suppressed.plugins.id=com.intellij.gradle
