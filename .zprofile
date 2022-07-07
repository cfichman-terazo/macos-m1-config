#! /bin/zsh
# Adds some nice shortcuts and functions to the zsh shell.
# Author: Chris Fichman
# Email: chris.fichman@terazo.com

source ~/.zuserconfig

export CURRENT_PROJECT_CONFIG=${HOME}/.z${CURRENT_PROJECT}
if [[ -f ${CURRENT_PROJECT_CONFIG} ]]; then
    source ${CURRENT_PROJECT_CONFIG}
fi

# Config check
if [[ -z ${PROFILE} || -z ${GIT_PROFILE} || -z ${GIT_EMAIL} || -z ${GIT_KEYNAME} ]]; then
  echo 'Essential variables in zprofile are not set. Open your .zprofile to update them.'
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
  ls -GFHltr $2
}
# Show all files in reverse time ordered list using LScolors
function lsa() {
  ls -GFHaltr $2
}
# Show only hidden files in reverse time ordered list using LScolors
function lsh() {
  ls -GFhltrd .*?
}

# Adds funciton to pipe diff to vim
function git_diff() {
    git diff --no-ext-diff -w "$@" | vim -R -
}

# Updates brew, updates brew libraries, cleans up unused/depricated, checks brew health
function brewup() {
  brew update;
  brew upgrade;
  brew upgrade --cask;
  brew cleanup;
  brew doctor;
}