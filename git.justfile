#!/usr/bin/env just --justfile

set shell := ["zsh", "-cu"] 
set dotenv-load := true
set positional-arguments := true

JUSTFILE_VERSION := "1.0.0"

PRJ_VERSION := `node -p "require('./package.json').version"`

# Update version using node: npm version <update_type> : major.minor.patch
_increment_version +type:
  npm version {{type}}

# Update version using sh 
@_set_ver +new_ver:
  echo version: {{PRJ_VERSION}}
  jq '. |= . + { "version": "{{new_ver}}" }' package.json > package.json.tmp
  mv package.json.tmp package.json
  echo Replaces with version {{new_ver}}

# Setup pre-commit as a Git hook
precommit:
    #!/usr/bin/env bash
    set -eo pipefail
    if [ -z "$SKIP_PRE_COMMIT" ] && [ ! -f ./pre-commit.pyz ]; then
      echo "Getting latest release"
      curl \
        ${GITHUB_TOKEN:+ --header "Authorization: Bearer ${GITHUB_TOKEN}"} \
        --output latest.json \
        https://api.github.com/repos/pre-commit/pre-commit/releases/latest
      cat latest.json
      URL=$(grep -o 'https://.*\.pyz' -m 1 latest.json)
      rm latest.json
      echo "Downloading pre-commit from $URL"
      curl \
        --fail \
        --location `# follow redirects, else cURL outputs a blank file` \
        --output pre-commit.pyz \
        ${GITHUB_TOKEN:+ --header "Authorization: Bearer ${GITHUB_TOKEN}"} \
        "$URL"
      echo "Installing pre-commit"
      python3 pre-commit.pyz install -t pre-push -t pre-commit
      echo "Done"
    else
      echo "Skipping pre-commit installation"
    fi


# _git_check_remote_branch *:
#   git fetch --prune
#   git ls-remote --heads ${REPO} ${BRANCH} | grep ${BRANCH} >/dev/null
#   if [ "$?" == "1" ] ; then echo "Branch doesn't exist"; exit; fi

hooks_init:
  #!/bin/bash
  dir="$PWD/.git/hooks"
  find "$dir" -type f -name "*.sample" | while read file
  do
    echo "Processing $file"
    filename=$(basename "$file")
    base="${filename%.*}"
    echo $base
    if [ -f "$dir/$base.sh" ]; then
      echo "File ${base}.sh exists"
    else
      cp $file $dir/$base.sh
    fi
  done