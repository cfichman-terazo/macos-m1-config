#! /bin/zsh
# Adds some nice shortcuts and functions to the zsh shell. 
# Do not add anything to this file that you don't want to be overwritten!
# Modify .zuserconfig to add special functionalty.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

source ~/.zuserconfig

export CURRENT_PROJECT_CONFIG=${HOME}/.z${CURRENT_PROJECT}
if [[ -f ${CURRENT_PROJECT_CONFIG} ]]; then
    source ${CURRENT_PROJECT_CONFIG}
fi

# Config check
if [[ -z ${PROFILE} || -z ${GIT_PROFILE} || -z ${GIT_EMAIL} || -z ${GIT_KEYNAME} ]]; then
  echo 'Essential variables in ~/.zuserconfig are not set. Open ~/.zuserconfig to update them.'
fi

# Development variables
export DEV_PATH=${HOME}/development

# ------------------------------------------------------------------------------------------------------------------------------------------------
# Common shell command shortcuts
# ------------------------------------------------------------------------------------------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
source ~/.zshrc

# Functions for LS
# Show files in reverse time ordered list using LScolos
function lsl() {
  ls -GFHltr $@
}
# Show all files in reverse time ordered list using LScolors
function lsa() {
  lsl -a $@
}
# Show only hidden files, folders and links in reverse time ordered list using LScolors
function lsh() {
  lsa --color=always $@ | egrep "([ \.[\d\dm]\.\w| \.\w)"
}

# Adds funciton to pipe diff to vim
function git_diff() {
    git diff --no-ext-diff -w "$@" | vim -R -
}