#!/usr/bin/env just --justfile

set shell := ["zsh", "-cu"] 
set dotenv-load := true
set positional-arguments := true

# Timestamp using to generate unic names
TIMESTAMP := `date +"%T"`
DATE := `date +%Y-%m-%d`

Project_Folder := trim_start_match( trim_start_match( absolute_path(justfile_directory()), parent_directory( justfile_directory() ) ), "/" )

Project_Name := `node -p "require('./package.json').name"`

PRJ_NAME := `{{Project_NPM_Name}} || {{Project_Folder_Name}}`

PRJ_VERSION := `node -p "require('./package.json').version"`

Project_Type := env_var_or_default("", "WP")

Curr_path := justfile_directory()/.justfile

echo_Curr:
  echo {{Curr_path}}

# ssh:
#   ssh $NAS_User@$NAS_Server -p $NAS_Port 

@_default: 
  just --list --unsorted

#init receipes as shell alias
@init_receipes-as-shell-alias:
  for recipe in `just --justfile {{justfile_directory()}}/.justfile --summary`; do
  alias $recipe="just --justfile {{justfile_directory()}}/.justfile --working-directory . $recipe"
  done

#remove receipe aliases
@remove_receipes-shell-alias:
  for recipe in `just --justfile ~/.user.justfile --summary`; do
  unalias $recipe
  done

# Find all .justfile files in the current directory and its subdirectories
find_justfiles:
  #!/bin/bash
  dir="."
  find "$dir" -type f -name "*.justfile" | while read file
  do
    echo "Processing $file"
  done

# @forvarding_aliases:
#   alias just.software='just --justfile .software.install.justfile --working-directory .'
#   alias just.wordpress='just --justfile .wordpress.justfile --working-directory .'
#   alias just.docker='just --justfile .docker.justfile --working-directory .'
#   alias just.aws='just --justfile aws.justfile --working-directory .'
#   alias just.git='just --justfile git.justfile --working-directory .'
#   alias just.idea='just --justfile idea.justfile --working-directory .'


#tar.bz2 project
@tar-bz2-project:
  rm -f ".temporary/{{Project_NPM_Name}}.tar.bz2"
  tar -C {{justfile_directory()}} --exclude=".temporary" --exclude-vcs-ignores -cjvf .temporary/{{Project_NPM_Name}}.tar.bz2 $( ls -a {{justfile_directory()}} | grep -v '\(^\.$\)\|\(^\.\.$\)' )

#untar.bz2 project
@untar-bz2-project:
  if [ ! -d {{Project_NPM_Name}} ]; then \
    mkdir {{Project_NPM_Name}} \
  else \
    tar -C {{Project_NPM_Name}} -cjvf .temporary/{{Project_NPM_Name}}.tar.bz2 $( ls -a {{justfile_directory()}} | grep -v '\(^\.$\)\|\(^\.\.$\)' )
  fi \
    && tar -xjvf {{Project_NPM_Name}}.tar.bz2 -C ~/projects/{{Project_NPM_Name}} \
    && rm -f ~/projects/{{Project_NPM_Name}}.tar.bz2


#backup picked files to NAS
@backup2nas +FILES:
  echo $NAS/$Project_Type/{{Project_NPM_Name}}/
  sudo scp -rf -P $NAS_Port {{FILES}} $NAS/$Project_Type/{{Project_NPM_Name}}/{{FILES}}

#backup project to NAS
@backup2nas-all:
  rm -f ".temporary/{{Project_NPM_Name}}.tar.bz2"
  tar -C {{justfile_directory()}} --exclude=".temporary" --exclude="{{Project_NPM_Name}}.tar.bz2" -cjvf .temporary/{{Project_NPM_Name}}.tar.bz2 $( ls -a {{justfile_directory()}} | grep -v '\(^\.$\)\|\(^\.\.$\)' )
  sudo scp -P $NAS_Port .temporary/{{Project_NPM_Name}}.tar.bz2 $NAS_User@$NAS_Server:~/projects
  ssh -p $NAS_Port $NAS_User@$NAS_Server 'cd ~/projects \
    && if [ ! -d "$DIRECTORY" ]; then mkdir {{Project_NPM_Name}} fi \
    && tar -xjvf {{Project_NPM_Name}}.tar.bz2 -C ~/projects/{{Project_NPM_Name}} \
    && rm -f ~/projects/{{Project_NPM_Name}}.tar.bz2'
# gpg --encrypt -r denys.hnatiuk@gmail.com 
# ssh -P $aliNAS_Port $aliNAS_User@$aliNAS_Server 'cat > ~/projects/$Project_Type.tar.gz.gpg'

# get .gitattributess from gist
get_gitattributes:
  sudo wget -O "/etc/.gitattributes" -H "Cache-Control: no-cache" https://gist.githubusercontent.com/DenysHnatiuk/40b1f11db14baffd7c01b2b05fd35075/raw/1a24b050b053a087b52751b95923c84acc7131f5/gitattributes.txt | tee > .gitattributes


# npm audit fix
npm-audit-fix:
  npm audit fix

# yarn audit fix 
yarn-audit-fix:
  #!/usr/bin/env bash
  npm i --package-lock-only
  npm audit fix --force
  rm yarn.lock
  yarn import
  rm package-lock.json

## PHP Toolkit

# PHPBrew
# PHP stdlib : PhpDotEnv, AutoLoader, ObjectBox, 
# XDebug
# Composer
# CodeSniffer
# Mess Detector
# CS Fixer
# PHP Stan
# Psalm
# Unit Tests
# PHP Frameworks : 
# PHP CMS :


# SASS Toolkit
_create-sassrc:
  touch .sassrc 
  echo '{ "includePaths": [ "node_modules" ] }' | tee -a .sassrc >/dev/null

