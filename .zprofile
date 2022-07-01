#! /bin/zsh
# Adds some nice shortcuts and functions to the zsh shell.

source ~/.zuserconfig

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

# ------------------------------------------------------------------------------------------------------------------------------------------------
# Docker Settings
# ------------------------------------------------------------------------------------------------------------------------------------------------
# export DOCKER_BUILDKIT=1

# ------------------------------------------------------------------------------------------------------------------------------------------------
# NVM Settings
# ------------------------------------------------------------------------------------------------------------------------------------------------
# export NODE_VERSION=node
# nvm use ${NODE_VERSION}

# ------------------------------------------------------------------------------------------------------------------------------------------------
# Library Paths and autocomplete. Enable as needed. 
# WARNING:Enabling too many autocomplete rules below this point may negatively impact shell performance!
# ------------------------------------------------------------------------------------------------------------------------------------------------
# Add Homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup NVM Path
export NVM_DIR="${HOME}/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Setup pyenv path
export PYENV_ROOT="${HOME}/.pyenv"
command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin:${PATH}"
#eval "$(pyenv init -)"

# Setup twilio autocomplete
#eval $(twilio autocomplete:script zsh)

# Setup Gcloud path and autocomplete
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cfichman/third-party/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/cfichman/third-party/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/cfichman/third-party/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cfichman/third-party/google-cloud-sdk/completion.zsh.inc'; fi