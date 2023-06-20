#!/usr/bin/env just --justfile

set shell := ["zsh", "-cu"] 
set dotenv-load := true
set positional-arguments := true

JUSTFILE_VERSION := "1.0.0"
IS_PROD := env_var_or_default("PROD", "")
IS_CI := env_var_or_default("CI", "")


Project_Name := trim_start_match( trim_start_match( absolute_path(justfile_directory()), parent_directory( justfile_directory() ) ), "/" )
Project_Type := env_var_or_default("WP", "")

ssh:
  ssh $NAS_User@$NAS_Server -p $NAS_Port 

@_default: 
  just --list --unsorted
  echo "Credentials:"
  echo "Justfile https://gist.github.com/DenysHnatiuk/a651e786d42c6bff32e5e41a15f53012"
  echo "Gist token is $GITHUB_GIST_TOKEN"

#backup files to NAS
@backup2nas +FILES:
  echo $NAS/$Project_Type/{{Project_Name}}/
  sudo scp -rf -P $NAS_Port {{FILES}} $NAS/$Project_Type/{{Project_Name}}/{{FILES}}

#backup project to NAS
@backup2nas-all:
  rm -f ".temporary/{{Project_Name}}.tar.bz2"
  tar -C {{justfile_directory()}} --exclude=".temporary" --exclude="{{Project_Name}}.tar.bz2" -cjvf .temporary/{{Project_Name}}.tar.bz2 $( ls -a {{justfile_directory()}} | grep -v '\(^\.$\)\|\(^\.\.$\)' )
  sudo scp -P $NAS_Port .temporary/{{Project_Name}}.tar.bz2 $NAS_User@$NAS_Server:~/projects
  ssh -p $NAS_Port $NAS_User@$NAS_Server 'cd ~/projects && mkdir {{Project_Name}} && tar -xjvf {{Project_Name}}.tar.bz2 -C ~/projects/{{Project_Name}} && rm -f ~/projects/{{Project_Name}}.tar.bz2'
# gpg --encrypt -r denys.hnatiuk@gmail.com 
# ssh -P $aliNAS_Port $aliNAS_User@$aliNAS_Server 'cat > ~/projects/$Project_Type.tar.gz.gpg'

_gitattributes:
  sudo wget -O "/etc/.gitattributes" -H "Cache-Control: no-cache" https://gist.githubusercontent.com/DenysHnatiuk/40b1f11db14baffd7c01b2b05fd35075/raw/1a24b050b053a087b52751b95923c84acc7131f5/gitattributes.txt | tee > .gitattributes

_init_receipes-as-shell-alias:
  for recipe in `just --justfile ~/.user.justfile --summary`; do
  alias $recipe="just --justfile ~/.user.justfile --working-directory . $recipe"
  done

_npm-audit-fix:
  npm audit fix

# yarn audit fix 
_yarn-audit-fix:
  #!/usr/bin/env bash
  npm i --package-lock-only
  npm audit fix --force
  rm yarn.lock
  yarn import
  rm package-lock.json

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



## Docker receipes

DOCKER_FILE := "-f " + (
    if IS_PROD == "true" { "prod/docker-compose.yml" }
    else { "docker-compose.yml" }
)


#SASS
_create-sassrc:
  touch .sassrc 
  echo '{ "includePaths": [ "node_modules" ] }' | tee -a .sassrc >/dev/null

_init-wp-theme:

_create-theme-style-css:
  touch style.css
  cat << EOF >>```
  @charset "UTF-8";
  /*!
  Theme Name: geliostrans
  Theme URI: https://github.com/DenysHnatiuk/cv/
  Author: Den Hnatiuk  
  Author URI: https://denyshnatiuk.github.io/geliostrans/ 
  Description: Description 
  Version: 0.0.1 
  Requires PHP: 5.6 
  Tested up to: 5.4 
  License: GNU General Public License v2 or later 
  License URI: LICENSE 
  Text Domain: geliostrans 
  Tags:  
  
  This theme, like WordPress, is licensed under the GPL. 
  */ ```EOF

# _git_check_remote_branch *:
#   git fetch --prune
#   git ls-remote --heads ${REPO} ${BRANCH} | grep ${BRANCH} >/dev/null
#   if [ "$?" == "1" ] ; then echo "Branch doesn't exist"; exit; fi