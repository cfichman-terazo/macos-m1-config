#! /bin/zsh
function first_time_setup () {
  setup_zprofile
  softwareupdate --install-rosetta
  sudo bash -c "xcode-select --install; xcodebuild -license accept"
}

function software_update () {
  sudo bash -c "softwareupdate -i -a"
}

## Copies zprofile from this folder and installs in home directory
function setup_zprofile() {
  ## Install and source .zprofile
  cp .zprofile ~
  cp .zshrc ~
  cp .zuserconfig ~
  vim ~/.zuserconfig

  source ~/.zprofile
}

## Install homebrew
function install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo ">>>>>>>>>>READ OUTPUT CAREFULLY AND UPDATE ZPROFILE IF NEEDED<<<<<<<<<<"
}

## Install and configure nvm
function install_nvm() {
  brew install nvm
  nvm install node
  nvm alias default node
  nvm use default
}

function install_aws() {
  brew install aws-shell
  brew install awscli
  brew install amazon-ecs-cli
}

## Install and configure python
function install_python() {
  brew install python
  pip3 install bitstring uritools nose tornado boto3
}

function install_c_deps() {
  brew install gcc
}

function install_languages() {
  install_python
  install_c_deps
  brew install go
}

function install_frameworks() {
  install_nvm
  brew install --cask docker
  brew install podman
  brew install kubernetes-cli
  install_aws
}

function install_databases() {
  brew install postgresql
  brew install --cask pgadmin4
}

# Install homebrew managed packages
function install_homebrew_packages () {
  install_languages
  install_frameworks
  # install_databases
}

## Create ssh-key and add to keychain
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
function git_gen_ssh_key() {
  if [ ! -f ${GIT_SSH} ]; then
    ssh-keygen -t ed25519 -f "${GIT_SSH}" -C "${USER_EMAIL}"
    cat << EOF > ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ${GIT_SSH}
EOF
  else
    echo "ssh file already exists, skipping generation."
  fi
  ## Turn on ssh agent and add key to keychain
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain ${GIT_SSH}
}

function brewup() {
  brew update;
  brew upgrade;
  brew upgrade --cask;
  brew cleanup;
  brew doctor;
}

run_first_time_setup="n"
run_system_update="n"
run_full_install="n"
run_brew_update="n"

function run_prompts(){
  echo "First time setup? (y/n):"
  read run_first_time_setup
  echo "Run software update? (y/n):"
  read run_software_update
  echo "Full install? (y/n):"
  read run_full_install
  echo "Update brew and packages? (y/n):"
  read run_update_brew
}

function main(){
  run_prompts
  if [ $run_software_update = "y" ]; then
    software_update
  fi
  if [ $run_first_time_setup = "y" ]; then
    first_time_setup
  fi
  if [ $run_full_install = "y" ]; then
    install_homebrew_packages
  fi
  if [ $run_update_brew = "y" ]; then
    brewup
  fi
}

main