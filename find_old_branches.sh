#!/usr/bin/env bash

set -e

usage() {
  echo
  echo "Returns old branches, based on last commit date"
  echo
  echo "Following options are supported:"
  echo
  echo " -o or --older-than to specify how old branches can be, defaults to --older-than '1 month ago'"
  echo "  see here for supported date formats: https://stackoverflow.com/questions/19742345/what-is-the-format-for-date-parameter-of-git-commit/19742762#19742762"
  echo
}

OLDER_THAN="1 month ago"

while [[ $# -gt 0 ]]
do
  cla="$1"
  shift
  case $cla in
    -o|--older-than)
    OLDER_THAN="$1"
    shift;;
    *)
    echo
    echo "Unrecognised option $cla"
    usage
    exit 1;;
  esac
done

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$SCRIPT_DIR/track_all_remote_branches.sh"

for branch in $(git branch | tr '*' ' '); do
  if [ -z "$(git log -1 --since=\'"$OLDER_THAN"\' -s $branch)" ]; then
    echo $branch
  fi
done
